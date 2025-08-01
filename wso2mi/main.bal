import ballerina/http;

// HTTP client to call Encryptbased64 service
http:Client encryptClient = check new ("http://localhost:9091");

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /GetInfo on httpDefaultListener {
    resource function post GetInfo(@http:Payload PayloadData payload) returns PayloadData|error {
        // Call Encryptbased64 service
        PayloadData encryptedPayload = check encryptClient->post(path = "/Encryptbased64/Encryptbased64", message = payload);
        return encryptedPayload;
    }
}

service /Encryptbased64 on new http:Listener(9091) {
    resource function post Encryptbased64(@http:Payload PayloadData payload) returns PayloadData|error {
        // Encode original usuario and senha to base64
        byte[] usuarioBytes = payload.pessoa.usuario.toBytes();
        string encodedUsuario = usuarioBytes.toBase64();

        byte[] senhaBytes = payload.pessoa.senha.toBytes();
        string encodedSenha = senhaBytes.toBase64();

        // Create a modified copy of the payload
        PayloadData modifiedPayload = {
            pessoa: {
                nome: payload.pessoa.nome,
                apelido: payload.pessoa.apelido,
                idade: payload.pessoa.idade,
                usuario: encodedUsuario,
                senha: encodedSenha,
                morada: {
                    rua: payload.pessoa.morada.rua,
                    cidade: payload.pessoa.morada.cidade,
                    codigo_postal: payload.pessoa.morada.codigo_postal,
                    pais: payload.pessoa.morada.pais
                }
            }
        };

        return modifiedPayload;
    }
}
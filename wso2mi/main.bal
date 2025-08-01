import ballerina/http;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /GetPayload on httpDefaultListener {
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

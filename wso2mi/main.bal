import ballerina/http;

// HTTP client to call Encryptbased64 service
http:Client encryptClient = check new ("http://localhost:9091");

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /GetInfo on httpDefaultListener {
    resource function post GetInfo(@http:Payload json payload) returns json|error {
        // Call Encryptbased64 service
        json encryptedPayload = check encryptClient->post(path = "/Encryptbased64/Encryptbased64", message = payload);
        return encryptedPayload;
    }
}

service /Encryptbased64 on new http:Listener(9091) {
    resource function post Encryptbased64(@http:Payload json payload) returns json|error {
        // Process the payload recursively to encrypt usuario and senha fields
        json encryptedPayload = check encryptFields(payload);
        return encryptedPayload;
    }
}

// Recursive function to encrypt usuario and senha fields
function encryptFields(json payload) returns json|error {
    if payload is map<json> {
        map<json> result = {};
        string[] keys = payload.keys();
        
        foreach string key in keys {
            json value = payload.get(key);
            
            if key == "usuario" || key == "senha" {
                if value is string {
                    byte[] valueBytes = value.toBytes();
                    string encodedValue = valueBytes.toBase64();
                    result[key] = encodedValue;
                } else {
                    result[key] = value;
                }
            } else {
                result[key] = check encryptFields(value);
            }
        }
        return result;
    } else if payload is json[] {
        json[] result = [];
        foreach json item in payload {
            json encryptedItem = check encryptFields(item);
            result.push(encryptedItem);
        }
        return result;
    } else {
        return payload;
    }
}
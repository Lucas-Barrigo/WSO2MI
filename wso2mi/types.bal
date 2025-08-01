// Define the address structure
public type Morada record {|
    string rua;
    string cidade;
    string codigo_postal;
    string pais;
|};

// Define the person structure
public type Pessoa record {|
    string nome;
    string apelido;
    int idade;
    string usuario;
    string senha;
    Morada morada;
|};

// Define the main payload structure
public type PayloadData record {|
    Pessoa pessoa;
|};
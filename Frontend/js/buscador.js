let data = [
    "juan",
    "perez",
    "luis",
    "alonso",
    "10258405",
    "541254641",
    "1254231452"
];

function buscar(){
    let query = document.getElementById("buscar").value;

    console.log(query);

    if(query.trim()=== ""){
        return;
    }

    let results = [];

    for(let i = 0; i < data.length; i++){
        if(data[i].toLowerCase().includes(query.toLowerCase())){
            results.push(data[i]);
        }
    }

    document.getElementById("results").innerHTML = "";

    if(results.length > 0){
        for(let i = 0; i < results.length; i++){
            let li=document.createElement("li");
            li.textContent = results[i];
            document.getElementById("results").appendChild(li);
        }
    }

    else{
        let li = document.createElement("li");
        li.textContent = "no se encontraron resultados:" + query;
        document.getElementById("result").appendChild(li);
    }
}


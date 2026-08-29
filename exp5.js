// Call back Function

function greet(name,callback){
    console.log("Hello "+name);
    callback();
    
}

function message(){
    console.log("Welcome");
    
}
greet("Sahil",message);


// SetTimeout
console.log("Satrt");
setTimeout(()=>{
    console.log("Inside call back");
    
},2000);

console.log("End");

// Promises
let promise = new Promise((res,rej)=>{
    let success = true;
    if(success){
        res("Data recived");
        
    }
    else{
        rej("promise rejected");
    }
});

promise.then((res)=> console.log(res)).catch(err => console.log(err));

// Async and Await Functio

function getData(){
    return new Promise((res)=>{
        setTimeout(()=>{
            res("Data resolved with setTimeout")
        },2000);
    });
}

async function showData(){
    let res = await getData();
    console.log(res);
    
}
showData();

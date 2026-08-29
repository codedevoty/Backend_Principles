// Promises

let promise = new Promise((resolve,reject)=>{
    let success = true;
    if(success){
        resolve("Task Completed");
    }
    else{
        reject("Task rejected");
    }
})

promise
.then((res)=>{
   console.log(res);
})
.catch(err=>{
    console.log(err);
})

// Promise with SetTimeout
let promises = new Promise((res,rej)=>{
    setTimeout(()=>{
        res("Data recived ");
    },2000);
});

promise.then((data)=>{
    console.log(data);
    
});


// async and await direction

async function greet(){
    return "hello"
}
greet.then(res =>{
    console.log(res);
    
})

// async and await
function getData(){
    return new Promise((res)=>{
        setTimeout(()=>{
            resolve("Data recieved");

        },2000);
    });
}

async function display(){
    let res = await getData();
    console.log(res);
    
}
display();


function getData(){
    return new Promise((res,rej)=>{
        let success = false;

        if(success){
            res("Data Recieved");
        }
        else{
            rej("Failed to fetch data");
        }
    });
}

async function display(){
    
    try{
      let res = await getData();
      console.log(res);
      
    }
    catch(err){
   console.log(err);
   
    } 

}
display();


let numbers = [1,2,3,4,5];

let res = numbers.map(x => x * 2);

let res1 = numbers.filter(x => x > 2);

let res2 = numbers.reduce((sum,x) => sum + x , 0);
console.log(res2);





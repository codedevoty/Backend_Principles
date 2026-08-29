class Animal{
    constructor(name){
        this.name = name;
    }
    eat(){
        console.log("Animal is eating");
        
    }
}

class Dog extends Animal{

    constructor(name,breed){
        super(name);
        this.breed = breed;
    }
    bark(){
        console.log("Dog is barking");
        
    }
    display(){
        console.log(this.name);
        console.log(this.breed);
        
        
    }
    eat(){
        console.log("Dog is eating");
        
    }
}

let d = new Dog("Tommy","retriver");
d.bark();
d.eat();
d.display();


class outer{

    createInner(){
        class Inner{
            display(){
                console.log("Inside inner class");
                
            }
            
        }

        let obj = new Inner();
        obj.display();
    }
}

let out = new outer();
out.createInner();


class student{
    setName(name){
        this.name = name;
        return this;
    }
    setAge(age){
        this.age = age;
        return this;
    }
    display(){
        console.log(this.name);
        console.log(this.age); 
        return this;
    }
}

let s = new student();
s.setAge(22);
s.setName("pu");
s.display();
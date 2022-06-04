// Need an empty constructor
@SuppressWarnings('PMD.EmptyBlockStatement')
public without sharing class Metric {
    public String name {get; set;}
    public Integer value {get; set;}
    public Integer max {get; set;}

    public Metric(){
    }

    public Metric(String name, Integer value, Integer max) {
        this.name = name;
        this.value = value;
        this.max = max;
    }
}
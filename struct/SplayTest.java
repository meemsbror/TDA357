public class SplayTest{



    public static void main (String args[]){

        SplayWithGet<String> a = new SplayWithGet<String>();

        a.add("zata");
        a.add("yolo");
        a.add("Hej");
        System.out.println(a.get("Hej")); 
        System.out.println(a.get("zata")); 
        System.out.println(a.get("yolo"));
        System.out.println(a.get("zata"));
    }
}

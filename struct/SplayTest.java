public class SplayTest{



    public static void main (String args[]){

        SplayWithGet<String> a = new SplayWithGet<String>();

        a.add("Hej");
        a.add("zata");
        a.add("yolo");
        System.out.println(a.get("yolo"));
        System.out.println(a.get("Hej"));
    }
}

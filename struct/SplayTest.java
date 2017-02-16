public class SplayTest{



    public static void main (String args[]){

        SplayWithGet<String> a = new SplayWithGet<String>();

        a.add("Denna");
        a.add("text");
        a.add("aar");
        System.out.println(a.get("zata"));

    }
}

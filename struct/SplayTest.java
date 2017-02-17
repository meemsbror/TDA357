public class SplayTest{



    public static void main (String args[]){

        SplayWithGet<String> a = new SplayWithGet<String>();

        a.add("Denna");
        a.add("text");
        System.out.println(a.get("text"));
        //System.out.println(a.checkRootRight());
        //System.out.println(a.get("text"));
        //System.out.println(a.checkRootRight());

    }
}

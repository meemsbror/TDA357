
/**
* A class for a Splay-tree
* 
*/
public class SplayWithGet<E extends Comparable<? super E>>
	extends BinarySearchTree<E>
	implements CollectionWithGet<E>{
		private class Splay_Entry extends Entry {

		private Splay_Entry( E element, Entry left, Entry right,Entry  parent ) {
			super( element, left, right, parent );
		}   //  constructor Splay_Entry

		private Splay_Entry( E element, Entry  parent   ) {
			super( element, null, null, parent );
		} //  constructor Splay_Entry

	}  //  class Splay_Entry
	
	/**
	*  Find the first occurence of an element 
	*  in the collection that is equal to the argument
	*  <tt>e</tt> with respect to its natural order.
	*  I.e. <tt>e.compateTo(element)</tt> is 0.
	*  
	*  @param e The dummy element to compare to.
	*  @return  An element  <tt>e'</tt> in the collection
	*           satisfying <tt>e.compareTo(e') == 0</tt>.
	*           If no element is found, <tt>null</tt> is returned
	*/
	public E get(E e) {
		if(e==null || root == null){
			return null;
		}
		Entry t = find(e,root);
		
		return t == null ? null : t.element;
	}  // get

	/**
	*  The constructor creates the empty tree
	*/
	public SplayWithGet() {
		super();
	}  // constructor SplayWithGet


	protected Entry find( E elem, Entry t ) {
		int jfr = elem.compareTo( t.element );
		if ( jfr  < 0 ){
			if(t.left == null){
				splay(t);
				return null;
			}
			return find( elem, t.left );
        }
		else if ( jfr > 0 ){
			if(t.right == null){
                splay(t);
                return null;
			}
			return find( elem, t.right );
        }
		else{
			splay(t);
			return root;
		}
	}  //   find


     /* Rotera 1 steg i hogervarv, dvs 
               x'                 y'
              / \                / \
             y'  C   -->        A   x'
            / \                    / \  
           A   B                  B   C
     */
	 private void zig( Entry x ) {
		 Entry   y = x.left;
		 E    temp = x.element;
		 x.element = y.element;
		 y.element = temp;
		 x.left    = y.left;

		 if ( x.left != null ){
			 x.left.parent   = x;
         }

		 y.left    = y.right;
		 y.right   = x.right;
		 if ( y.right != null ){
			 y.right.parent  = y;
         }

		 x.right   = y;
	 } //   rotateRight
        
     /* Rotera 1 steg i vanstervarv, dvs 
               x'                 y'
              / \                / \
             A   y'  -->        x'  C
                / \            / \  
               B   C          A   B   
     */
	 private void zag( Entry x ) {
		 Entry  y  = x.right;
		 E temp    = x.element;
		 x.element = y.element;
		 y.element = temp;
		 x.right   = y.right;
		 if ( x.right != null )
			 x.right.parent  = x;
		 y.right   = y.left;
		 y.left    = x.left;
		 if ( y.left != null )
			 y.left.parent   = y;
		 x.left    = y;
	 } //   rotateLeft

     /* Rotera 2 steg i hogervarv, dvs 
               x'                  z'
              / \                /   \
             y'  D   -->        y'    x'
            / \                / \   / \
           A   z'             A   B C   D
              / \  
             B   C  
     */
   private void zigZag( Entry x ) {
        Entry   y = x.left,
	        z = x.left.right;
        E       e = x.element;
        x.element = z.element;
        z.element = e;
        y.right   = z.left;
        if ( y.right != null )
	    y.right.parent = y;
        z.left    = z.right;
        z.right   = x.right;
        if ( z.right != null )
	    z.right.parent = z;
        x.right   = z;
        z.parent  = x;
    }  //  doubleRotateRight
	
    /* Rotera 2 steg i vanstervarv, dvs 
               x'                  z'
              / \                /   \
             A   y'   -->       x'    y'
                / \            / \   / \
               z   D          A   B C   D
              / \  
             B   C  
     */
    private void zagZig( Entry x ) {
        Entry  y  = x.right, z  = x.right.left;
        E      e  = x.element;
        x.element = z.element;
        z.element = e;
        y.left    = z.right;
        if ( y.left != null )
	    y.left.parent = y;
        z.right   = z.left;
        z.left    = x.left;
        if ( z.left != null )
	    z.left.parent = z;
        x.left    = z;
        z.parent  = x;
    } //  doubleRotateLeft

/*
           z                x
          / \              / \
         y   D            A   y
        / \                  / \
       x   C      <--       B   z
      / \                      / \
     A   B                    C   D
*/
    private void zigZig( Entry x){

        Entry y = x.right;
        Entry z = y.right;

        //switch x and z elements
        E e = z.element;

        z.element = x.element;
        x.element = e;

        //move the subtrees to right pos
        x.right = z.right;
        y.right = z.left;
        z.left = x.left;
        z.right = y.left;
        
        x.left = y;
        y.left = z;

		//Sort out the childrens parents. x y z already has the correct parents
        if(x.right != null){
            x.right.parent = x;
        }

        if(y.right != null){
            y.right.parent = y;
        }
        
        if(z.left != null){
            z.left.parent = z;
        }

        if(z.right != null){
            z.right.parent = z;
        }
    }
/*
           x                z
          / \              / \
         y   D            A   y
        / \                  / \
       z   C       -->      B   x
      / \                      / \
     A   B                    C   D
*/
    private void zagZag(Entry x){

        Entry y = x.left;
        Entry z = y.left;

        //Switch the elements in x and z
        E e = z.element;
        z.element = x.element;
        x.element = e;

        //move the subtrees to right pos
        x.left = z.left;
        y.left = z.right;
        z.left = y.right;
        z.right = x.right;

        x.right = y;
        y.right = z;

        //Sort out the childrens parents. x y z already has the correct parents
        if(x.left != null){
            x.left.parent = x;
        }

        if(y.left != null){
            y.left.parent = y;
        }

        if(z.right != null){
            z.right.parent = z;
        }

        if(z.left != null){
            z.left.parent = z;
        }
    }
    private boolean splay(Entry x){

        if(x.parent == null){
            root = x;
            return true;
        }

        Entry y = x.parent;

        //if one step from root
        if(y.parent == null){

            if(y.right == x){
                zag(y);
            }else{
                zig(y);
            }
            root = y;
            return true;
        }

        Entry z = y.parent;

        if(y == z.right){
            if(x == y.right){
                //Right right child
                zigZig(z);

            }else{
                //Right left child
                zagZig(z);
            }
        }else{
            if(x == y.right){
                //Left right child
                zigZag(z);
            }else{
                //Left left child
                zagZag(z);
            }
        }
        return splay(z);
    }


    public boolean checkRootRight(){

        if(root.right == null){
            return true;
        }
        else{
            return false;
        }

    }
}

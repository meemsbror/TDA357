
/**
*
*
*
*/
public class SplayWithGet<E extends Comparable<? super E>>
	extends BinarySearchTree<E>
	implements CollectionWithGet<E>{
		private class Splay_Entry extends Entry {

		//TODO: Some javadoc

		private Splay_Entry( E element, Entry left, 
			Entry  right,
			Entry  parent ) {
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
		Entry t = find(e,root);
		return t == null ? null : t.element;
	}  // get

	/**
	*  The constructor creates the empty tree
	*/
	public SplayWithGet() {
		super();
	}  // constructor SplayWithGet

	/**
	* Add the element to its first proper empty place.
	* @param elem the element to be included  
	*/
	public boolean add(E elem) {
		if ( root == null ){
			root = new Splay_Entry( elem, null );
		}
		else{
			addInSplay( elem , root );
		}
		return true; 
	} // add

	private boolean addInSplay( E newElem, Entry t ) {

        //Put in left
		if ( newElem.compareTo( t.element ) < 0 ) {
			if ( t.left == null ) { 
				t.left = new Splay_Entry( newElem, t );
			}
			else {
				boolean left = addInSplay( newElem, t.left );
			}
			return true;
		}

        //Put to right
		else {
			if ( t.right == null ) { 
				t.right = new Splay_Entry( newElem, t );
				checkHeight(t);
			}
			else {
				boolean left = addInSplay( newElem, t.right );
				if ( height(t.right) - height(t.left) > 1 ) {
					if ( left )
						doubleRotateLeft( t );
					else 
						rotateLeft( t );
				}
				else
					checkHeight(t); 
			}
		}
		return false;
	}  //   addInAVL





	/**
	* Remove the first occurance of an element with the same key
	* as the argument element. 
	* If no element is removed false is returned,
	* otherwise true is returned.
	* After the element is removed the height balance
	* is checked and if nescessary restored.
	* 
	* @param elem any element with the searched key
	* @return true if an element has disapeared from the tree,
	*         false otherwise
	*/
	public boolean remove( E elem ) {
		if ( root == null )
			return false;
		else if ( root.element.compareTo(elem) == 0 && 
		(root.left == null || root.right == null ) ){
			root = root.left == null ? root.right : root.left;
			size--;
			return true;
		}
		else {
			int oldSize = size;
			remove( elem, root);
			return size != oldSize;
		}
	} // remove 
	// ========== ========== ========== ==========

	//  In order to make the iterator in 
	//  BinarySearchTree to work properly !!
	protected void removeThis( Entry t ) {
		remove( t.element, root );
	}  //  removeThis 
	// ========== ========== ========== ==========
	
	private void remove(  E elem, Entry x ) {
		if ( elem.compareTo( x.element ) == 0 )
		if ( x.left == null || x.right == null ) {
			Entry newX =  x.left == null ? x.right : x.left;
			if ( newX != null )
				newX.parent = x.parent;
			if ( x.parent.left == x )
				x.parent.left = newX;
			else
				x.parent.right = newX;
			size--;
			return;
		}
		else {
			Entry t = x.left; //x.element = findRefToMostRight( x.left ).element;
			while( t.right != null )//
				t = t.right;       //
			x.element = t.element; //
			remove( x.element, x.left );
        }
		else 
		if ( elem.compareTo( x.element ) < 0 ) {
			if ( x.left != null ) {
				remove( elem, x.left );
            }
		}
		else 
		if ( x.right != null ) {
			remove( elem, x.right );
			}
	}  // remove private version              





     /* Rotera 1 steg i hogervarv, dvs 
               x'                 y'
              / \                / \
             y'  C   -->        A   x'
            / \                    / \  
           A   B                  B   C
     */
	 private void rotateRight( Entry x ) {
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
		 checkHeight( y );
		 checkHeight( x );
	 } //   rotateRight
	 // ========== ========== ========== ==========
	 



        
     /* Rotera 1 steg i vanstervarv, dvs 
               x'                 y'
              / \                / \
             A   y'  -->        x'  C
                / \            / \  
               B   C          A   B   
     */
	 private void rotateLeft( Entry x ) {
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
		 checkHeight( y );
		 checkHeight( x );
	 } //   rotateLeft
	 // ========== ========== ========== ==========

     /* Rotera 2 steg i hogervarv, dvs 
               x'                  z'
              / \                /   \
             y'  D   -->        y'    x'
            / \                / \   / \
           A   z'             A   B C   D
              / \  
             B   C  
     */
   private void doubleRotateRight( Entry x ) {
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
        checkHeight( z );
        checkHeight( y );
        checkHeight( x );
    }  //  doubleRotateRight
	// ========== ========== ========== ==========
	
    /* Rotera 2 steg i vanstervarv, dvs 
               x'                  z'
              / \                /   \
             A   y'   -->       x'    y'
                / \            / \   / \
               z   D          A   B C   D
              / \  
             B   C  
     */
    private void doubleRotateLeft( Entry x ) {
        Entry  y  = x.right,
	z  = x.right.left;
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
	// ========== ========== ========== ==========
/*
           x                x
          / \              / \
         y   D            A   y
        / \                  / \
       z   C      <-->      B   z
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
        
        if(z.left != null){
            z.left.parent = z;
        }

        if(z.right != null){
            z.right.parent = z;
        }
    }
/*
           x                x
          / \              / \
         y   D            A   y
        / \                  / \
       z   C      <-->      B   z
      / \                      / \
     A   B                    C   D
*/
    private void zagzag(Entry x){

        Entry y = x.left;
        Entry z = y.left;

        //Switch the elements in x and z
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

        if(z.right != null){
            z.right.parent = z;
        }

        if(z.left != null){
            z.left.parent = z;
        }
    }
}


import java.util.*;

/**
* Class for a sorted linked list
**/
public class SLCWithGet<E extends Comparable<? super E>> 
			extends LinkedCollection<E>
			implements CollectionWithGet<E> {
	/**
	* New add method to sort the linked list
	* Adds an element to the collection and 
	* puts it in the correct position. 
	* The first element in the collection will be 
	* the smallest element. 
	*
	* @param element the object to add into the list
	* @return true if the object has been added to the list.
	* @throws NullPointerException if parameter <tt>element<tt> is null. 
	*/
	@Override 
	public boolean add(E element){
		if ( element == null ){
			throw new NullPointerException();
		}
		else {
			if(isEmpty()){
				head = new Entry(element, head);
				return true;
			}else{
				return addCompare(head.next, head, element);
			}
		}
	}

	private boolean addCompare(Entry current, Entry previous, E newElement){

		//check if new element is less than or equal to current element
		if(current == null || newElement.compareTo(current.element) < 1 ){
			Entry e = new Entry(newElement, current);
			previous.next = e;
			return true;
		}
		return addCompare(current.next, current, newElement);
	}

	public E get(E e){
		return getThatShit(head, e);
	}

	private E getThatShit(Entry entry, E e){
		if(entry != null){
			if(entry.element.compareTo(e) == 0){
				return entry.element;
			}

			return getThatShit(entry.next, e);
		}
		return null;
	}

}

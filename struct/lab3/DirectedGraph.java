import java.util.*;
/**
* Class which can represent a directed graph 
* */
public class DirectedGraph<E extends Edge> {

    int[] nodes;
    List<E> EL;
    int noOfNodes;
  /**
  * Creates an directed graph with an array (nodes)
  * with all the nodes and an ArrayList
  * which can be filled with the edges
  * @param noOFNodes the number of nodes the graph contains
  */
	public DirectedGraph(int noOfNodes) {
        nodes = new int[noOfNodes+1];
        EL = new ArrayList<E>();
        this.noOfNodes = noOfNodes;
	}
    /**
    * Adds the edge to the list with edges
    *@param e the edge to be added
    */
	public void addEdge(E e) {
        EL.add(e);
	}

    /**
    * Finds the shortes path from the node "from" to 
    * the node "to"
    *@param from the node to start in
    *@param to the node to finisih in
    *@return iteretor with edges in order as the shortest path 
    */
	public Iterator<E> shortestPath(int from, int to) {
		return djikstra(from,to);
	}
	
    /**
    * Connects all nodes in the cheapest way possible creating a minimum spanning tree.
    * @return iteretor with edges which will give the minimum spanning tree
    */
	public Iterator<E> minimumSpanningTree() {
		return kruskal();
	}

    private Iterator<E> kruskal(){

    ArrayList<List<E>> cc = new ArrayList<List<E>>();
    for(int i = 0; i < noOfNodes; i++){
      cc.add(new LinkedList<E>());
    }    

    PriorityQueue<CompKruskalEdge> pq = new PriorityQueue<CompKruskalEdge>();

    for(E e : EL){
      pq.add(new CompKruskalEdge(e));
    }

    int n = noOfNodes;
    E temp;
    List<E> from;
    List<E> to;
    List<E> big;
    List<E> small;
      
    while(!pq.isEmpty() && n>=1){

      temp = pq.poll().edge;

      from = cc.get(temp.from);
      to = cc.get(temp.to);

      if(from != to){
        if(from.size()<to.size()){
            big = to;
            small = from;
        }
        else{
            big = from;
            small = to;
        }

        big.addAll(small);
        big.add(temp);
        cc.set(temp.from, big);
        cc.set(temp.to, big);
        
        for(E e: small){
            cc.set(e.to, big);
            cc.set(e.from, big);
        }
        n--;
      }
    }
    if(cc.get(0).size() == noOfNodes -1){
      return cc.get(0).iterator();
    }
    return null;
  }

    private class CompKruskalEdge implements Comparable<CompKruskalEdge>{
        E edge;

        public CompKruskalEdge(E edge){
        this.edge = edge;
        }

        public int compareTo(CompKruskalEdge e){
            if(e.edge.getWeight()>this.edge.getWeight()){
                return -1;
            }
            if(e.edge.getWeight()<this.edge.getWeight()){
                return 1;
            }
        return 0;
        }
    }


    private Iterator<E> djikstra(int from, int to){

    //Mark all the nodes as unvisited
    for(int i = 0; i < nodes.length; i++){
      nodes[i] = 0;
    }

    PriorityQueue<CompDijkstraPath> q = new PriorityQueue<CompDijkstraPath>();

    ArrayList<E> list = new ArrayList<E>();
    q.add(new CompDijkstraPath(from,0, list));

    CompDijkstraPath tmpQE;
    while(!q.isEmpty()){
       tmpQE = q.poll();
       if(nodes[tmpQE.to] != -1){
            if(tmpQE.to == to){
                return tmpQE.path.iterator();
            } 
            else{
                nodes[tmpQE.to] = -1;

                for(E e: EL){
                    if(e.from == tmpQE.to){
                        if(nodes[e.to] != -1){
                            list = tmpQE.path;
                            list = (ArrayList<E>) list.clone();
                            list.add(e);
                            q.add(new CompDijkstraPath(e.to,
                                        tmpQE.cost + e.getWeight(),
                                        list));
                        }
                    }
                }
            }
         }
     }
     return null;
  }


   private class CompDijkstraPath implements Comparable<CompDijkstraPath>{
     int to;
     double cost;
     ArrayList<E> path;

     CompDijkstraPath(int to, double cost, ArrayList<E> path){

         this.to = to;
         this.cost = cost;
         this.path = path;
     }

     public int compareTo(CompDijkstraPath q){
         if(q.cost>this.cost){
             return -1;
         }

         if(q.cost<this.cost){
             return 1;
         }
         return 0;
     }
   }

}
  

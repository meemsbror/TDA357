import java.util.*;
/**
**/
public class DirectedGraph<E extends Edge> {

    int[] nodes;
    List<E>[] MF;
    List<E> EL;

	public DirectedGraph(int noOfNodes) {
        nodes = new int[noOfNodes+1];
        EL = new ArrayList<E>();
        MF = new List<E>[noOfNodes];
	}

	public void addEdge(E e) {
        EL.add(e);
	}

	public Iterator<E> shortestPath(int from, int to) {
        for(int i = 0; i < nodes.length; i++){
            nodes[i] = 0;
        }

        List<E> dj = djikstra(from,to);
		return dj == null ? null : dj.iterator();

	}
		
	public Iterator<E> minimumSpanningTree() {
		return null;
	}


    priva

    private ArrayList<E> djikstra(int from, int to){

        PriorityQueue<QueueElement> q = new PriorityQueue<QueueElement>();

        ArrayList<E> list = new ArrayList<E>();
        q.add(new QueueElement(from,0, list));

        QueueElement tmpQE;
        while(!q.isEmpty()){
            tmpQE = q.poll();
            if(nodes[tmpQE.to + 1] != -1){
                if(tmpQE.to == to){
                    return tmpQE.path;
                } 
                else{
                    nodes[tmpQE.to + 1] = -1;

                    for(E e: EL){
                        if(e.from == tmpQE.to){
                            if(nodes[e.to + 1] != -1){
                                list = tmpQE.path;
                                list = (ArrayList<E>) list.clone();
                                list.add(e);
                                q.add(new QueueElement(e.to,
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


    private class QueueElement implements Comparable<QueueElement>{


        int to;
        double cost;
        ArrayList<E> path;

        QueueElement(int to, double cost, ArrayList<E> path){

            this.to = to;
            this.cost = cost;
            this.path = path;
        }

        public int compareTo(QueueElement q){
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
  

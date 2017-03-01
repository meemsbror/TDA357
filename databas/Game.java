/* This is the driving engine of the program. It parses the command-line
 * arguments and calls the appropriate methods in the other classes.
 *
 * You should edit this file in three ways:
 * 1) Insert your database username and password in the proper places.
 * 2) Implement the generation of the world by reading the world file.
 * 3) Implement the three functions showPossibleMoves, showPlayerAssets
 *    and showScores.
 */
import java.math.BigDecimal;
import java.net.URL;
import java.sql.*; // JDBC stuff.
import java.util.Calendar;
import java.util.Map;
import java.util.Properties;
import java.io.*;  // Reading user input.
import java.util.ArrayList;
import java.util.concurrent.Executor;

public class Game
{
	public class Player
	{
		String playername;
		String personnummer;
		String country;
		private String startingArea;

		public Player (String name, String nr, String cntry, String startingArea) {
			this.playername = name;
			this.personnummer = nr;
			this.country = cntry;
			this.startingArea = startingArea;
		}
	}

 	String USERNAME = "USERNAME";
 	String PASSWORD = "PASSWORD";

	/* Print command optionssetup.
	* /!\ you don't need to change this function! */
	public void optionssetup() {
		System.out.println();
		System.out.println("Setup-Options:");
		System.out.println("		n[ew player] <player name> <personnummer> <country>");
		System.out.println("		d[one]");
		System.out.println();
	}

 	/* Print command options.
 	* /!\ you don't need to change this function! */
 	public void options() {
		System.out.println("\nOptions:");
		System.out.println("    n[ext moves] [area name] [area country]");
		System.out.println("    l[ist properties] [player number] [player country]");
		System.out.println("    s[cores]");
		System.out.println("    r[efund] <area1 name> <area1 country> [area2 name] [area2 country]");
		System.out.println("    b[uy] [name] <area1 name> <area1 country> [area2 name] [area2 country]");
		System.out.println("    m[ove] <area1 name> <area1 country>");
		System.out.println("    p[layers]");
		System.out.println("    q[uit move]");
		System.out.println("    [...] is optional\n");
	}

	/* Given a town name, country and population, this function
 	 * should try to insert an area and a town (and possibly also a country)
 	 * for the given attributes.
 	 */
	void insertTown(Connection conn, String name, String country, String population) throws SQLException  {

		try{
			PreparedStatement ps;
			try{
				ps = conn.prepareStatement("INSERT INTO Countries (name) VALUES (?)");
				ps.setString(1,country);
				ps.executeUpdate();
			}catch(SQLException e){
                //Country already existed all is as it should be
            }

			ps = conn.prepareStatement("INSERT INTO Areas (country, name, population) VALUES (?,?,cast(? as INT))");
			ps.setString(1,country);
			ps.setString(2,name);
			ps.setString(3,population);
			ps.executeUpdate();

			ps = conn.prepareStatement("INSERT INTO Towns VALUES (?,?)");
			ps.setString(1,country);
			ps.setString(2,name);
			ps.executeUpdate();


		}catch(SQLException e){
			System.out.println("Insertion of Town failed \n" + e.getMessage());
		}
	}

	/* Given a city name, country and population, this function
 	 * should try to insert an area and a city (and possibly also a country)
 	 * for the given attributes.
 	 * The city visitbonus should be set to 0.
 	 */
	void insertCity(Connection conn, String name, String country, String population) throws SQLException {
		try{
			PreparedStatement ps;
			try{
				ps = conn.prepareStatement("INSERT INTO Countries (name) VALUES (?)");
				ps.setString(1,country);
				ps.executeUpdate();
			}catch(SQLException e){}

			ps = conn.prepareStatement("INSERT INTO Areas (country, name, population) VALUES (?,?,cast(? as INT))");
			ps.setString(1,country);
			ps.setString(2,name);
			ps.setString(3,population);
			ps.executeUpdate();

			ps = conn.prepareStatement("INSERT INTO Towns VALUES (?,?,cast(? as NUMERIC))");
			ps.setString(1,country);
			ps.setString(2,name);
			ps.setString(3,"0")
			ps.executeUpdate();


		}catch(SQLException e){
			System.out.println("Insertion of Town failed \n" + e.getMessage());
		}
	}

	/* Given two areas, this function
 	 * should try to insert a government owned road with tax 0
 	 * between these two areas.
 	 */
	void insertRoad(Connection conn, String area1, String country1, String area2, String country2) throws SQLException {
		try{
			PreparedStatement ps = conn.prepareStatement("INSERT INTO Roads (fromcountry,fromarea,tocountry,toarea,ownercountry,
    														ownerpersonnummer,roadtax) VALUES (?,?,?,?,?,?,cast(? as NUMERIC))");
			ps.setString(1,country1);
			ps.setString(2,area1):
			ps.setString(3,country2)
			ps.setString(4,area2);
			ps.setString(5,"");
			ps.setString(6,"");
			ps.setString(7,"0")
			ps.executeUpdate();

		}catch(SQLException e){
			System.out.println("Insertion of Road failed \n" + e.getMessage());
		}
	}

	/* Given a player, this function
	 * should return the area name of the player's current location.
	 */
	String getCurrentArea(Connection conn, Player person) throws SQLException {
		ResultSet rs;
		try{
			PreparedStatement ps = conn.prepareStatement("SELECT locationarea FROM Persons WHERE personnummer=(?) AND country=(?)");
			ps.setString(1,person.personnummer);
			ps.setString(2,person.country);
			rs = ps.executeQuery();
			rs.next();
		}catch(SQLException e){
			return null;
		}
		return rs.getString(1);
	}

	/* Given a player, this function
	 * should return the country name of the player's current location.
	 */
	String getCurrentCountry(Connection conn, Player person) throws SQLException {
		ResultSet rs;
		try{
			PreparedStatement ps = conn.prepareStatement("SELECT locationcountry FROM Persons WHERE personnummer=(?) AND country=(?)");
			ps.setString(1,person.personnummer);
			ps.setString(2,person.country);
			rs = ps.executeQuery();
			rs.next();
		}catch(SQLException e){
			return null;
		}
		return rs.getString(1);
	}

	/* Given a player, this function
 	 * should try to insert a table entry in persons for this player
	 * and return 1 in case of a success and 0 otherwise.
 	 * The location should be random and the budget should be 1000.
	 */
	int createPlayer(Connection conn, Player person) throws SQLException {
		try{
			PreparedStatement area = conn.prepareStatement("SELECT country,name FROM Areas ORDER BY Random")
			ResultSet rs = area.executeQuery();
			rs-next();
			PreparedStatement ps = conn.prepareStatement("INSERT INTO Persons 
				(country, personnummer,name,budget,locationcountry,locationarea) 
				VALUES (?,?,?,cast(? as NUMERIC),?,?),");
			ps.setString(1,player.country);
			ps.setString(2,player.personnummer):
			ps.setString(3,player.playername)
			ps.setString(4,"1000");
			ps.setString(5,rs.getString("country"));
			ps.setString(6,rs.getString("name"));

		}catch(SQLException e){
			System.out.println("Insertion of Road failed \n" + e.getMessage());
		}
	}

	/* Given a player and an area name and country name, this function
	 * sould show all directly-reachable destinations for the player from the
	 * area from the arguments.
	 * The output should include area names, country names and the associated road-taxes
 	 */
	void getNextMoves(Connection conn, Player person, String area, String country) throws SQLException {
		// TODO: Your implementation here
	    
		// TODO TO HERE
 	}

	/* Given a player, this function
  	 * sould show all directly-reachable destinations for the player from
	 * the player's current location.
	 * The output should include area names, country names and the associated road-taxes
	 */
	void getNextMoves(Connection conn, Player person) throws SQLException {
		// TODO: Your implementation here
		// hint: Use your implementation of the overloaded getNextMoves function
	    
		// TODO TO HERE
	}

	/* Given a personnummer and a country, this function
	 * should list all properties (roads and hotels) of the person
	 * that is identified by the tuple of personnummer and country.
	 */
	void listProperties(Connection conn, String personnummer, String country) {
        try{
			PreparedStatement ps;
            ps = conn.prepareStatement("SELECT * FROM hotels " +
                    "WHERE ownerpersonnummer = ? AND ownercountry = ?");
            ResultSet rs = ps.executeQuery();
            System.out.println("These are the hotels of that person:");
            while(rs.next()){
                for(int i = 1; i <= 5; i++){
                    System.out.print(rs.getString(i) + " : ")
                }
                System.out.println();
            }
        }catch(SQLException e){
            System.out.prinln(e.getMessage());
        }

        try{
			PreparedStatement ps;
            ps = conn.prepareStatement("SELECT * FROM roads" +
                    "WHERE ownerpersonnummer = ? AND ownercountry = ?");
            ResultSet rs = ps.executeQuery();
            System.out.println("These are the roads of that person:");
            while(rs.next()){
                for(int i = 1; i <= 5; i++){
                    System.out.print(rs.getString(i) + " : ")
                }
                System.out.println();
            }
        }catch(SQLException e){
            System.out.prinln(e.getMessage());
        }
		
	}

	/* Given a player, this function
	 * should list all properties of the player.
	 */
	void listProperties(Connection conn, Player person) throws SQLException {
        listProperties(person.personnummer, person.country);
	}

	/* This function should print the budget, assets and refund values for all players.
	 */
	void showScores(Connection conn) throws SQLException {
    try{
			PreparedStatement ps;
            ps = conn.prepareStatement("SELECT * FROM assetsummary ");
            ResultSet rs = ps.executeQuery();
            System.out.println("These are the assets:");
            while(rs.next()){
                for(int i = 1; i <= 4; i++){
                    System.out.print(rs.getString(i) + " : ")
                }
                System.out.println();
            }
        }catch(SQLException e){
            System.out.prinln(e.getMessage());
        }
		
	}

	/* Given a player, a from area and a to area, this function
	 * should try to sell the road between these areas owned by the player
	 * and return 1 in case of a success and 0 otherwise.
	 */
	int sellRoad(Connection conn, Player person, String area1, String country1, String area2, String country2) throws SQLException {
		try{
			PreparedStatement ps;
            ps = conn.prepareStatement("DELETE FROM roads" + 
                "WHERE fromcountry = ? AND fromarea = ? AND " +
                "tocountry  = ? AND toarea = ? AND " + 
                "ownercountry = ? AND ownerpersonnummer = ? ");
            ps.setString(1,country1);
            ps.setString(2,area1);
            ps.setString(3,country2);
            ps.setString(4,area2);
            ps.setString(5,pesron.country);
            ps.setString(6,person.personnummer);
            ps.executeUpdate();
            return 1;
        }catch(SQLException e){
            System.out.prinln(e.getMessage());
        }


        try{
			PreparedStatement ps;
            ps = conn.prepareStatement("DELETE FROM roads" + 
                "WHERE fromcountry = ? AND fromarea = ? AND " +
                "tocountry  = ? AND toarea = ? AND " + 
                "ownercountry = ? AND ownerpersonnummer = ? ");
            ps.setString(1,country2);
            ps.setString(2,area2);
            ps.setString(3,country1);
            ps.setString(4,area1);
            ps.setString(5,pesron.country);
            ps.setString(6,person.personnummer);
            ps.executeUpdate();
            return 1;
        }catch(SQLException e){
            System.out.prinln(e.getMessage());
        }

        return 0;

	}

	/* Given a player and a city, this function
	 * should try to sell the hotel in this city owned by the player
	 * and return 1 in case of a success and 0 otherwise.
	 */
	int sellHotel(Connection conn, Player person, String city, String country) throws SQLException {

        try{
			PreparedStatement ps;
            ps = conn.prepareStatement("DELETE FROM hotels" + 
                "WHERE locationcountry = ? AND locationname = ? AND " +
                "ownercountry = ? AND ownerpersonnummer = ? ");
            ps.setString(1,country);
            ps.setString(2,city);
            ps.setString(3,pesron.country);
            ps.setString(4,person.personnummer);
            ps.executeUpdate();
        }catch(SQLException e){
            System.out.prinln(e.getMessage());
            return 0;
        }
        return 1;
	}

	/* Given a player, a from area and a to area, this function
	 * should try to buy a road between these areas owned by the player
	 * and return 1 in case of a success and 0 otherwise.
	 */
	int buyRoad(Connection conn, Player person, String area1, String country1, String area2, String country2) throws SQLException {

        try{
			PreparedStatement ps;
            ps = conn.prepareStatement("INSERT INTO roads (fromcountry,fromarea,tocountry,toarea, ownercountry, ownerpersonnummer) VALUES (?,?,?,?,?,?)");
            ps.setString(1,area1);
            ps.setString(2,country1);
            ps.setString(3,area2);
            ps.setString(4,country2);
            ps.setString(5,person.country);
            ps.setString(6,person.personnummer);
            ps.executeUpdate();
        }catch(SQLException e){
            System.out.prinln(e.getMessage());
            return 0;
        }
    return 1;
	}

	/* Given a player and a city, this function
	 * should try to buy a hotel in this city owned by the player
	 * and return 1 in case of a success and 0 otherwise.
	 */
	int buyHotel(Connection conn, Player person, String name, String city, String country) throws SQLException {

	    try{
			PreparedStatement ps;
            ps = conn.prepareStatement("INSERT INTO hotels (name, locationcountry, locationname, ownercountry, ownerpersonnummer) VALUES (?,?,?,?,?)");
            ps.setString(1,name);
            ps.setString(2,country);
            ps.setString(3,city);
            ps.setString(4,person.country);
            ps.setString(5,person.personnummer);
            ps.executeUpdate();
        }catch(SQLException e){
            System.out.prinln(e.getMessage());
            return 0;
        }
    return 1;
	}

	/* Given a player and a new location, this function
	 * should try to update the players location
	 * and return 1 in case of a success and 0 otherwise.
	 */
	int changeLocation(Connection conn, Player person, String area, String country) throws SQLException {
		try{
			PreparedStatement ps;
            ps = conn.prepareStatement("UPDATE persons " +
                   "SET locationarea = ?, locationcountry = ? " +
                   "WHERE personnummer = ? AND country = ?");
            ps.setString(1,area);
            ps.setString(2,country);
            ps.setString(3,person.personnummer);
            ps.setString(4,person.country);
            ps.executeUpdate();
        }catch(SQLException e){
            System.out.prinln(e.getMessage());
            return 0;
        }
    return 1;
	}

	/* This function should add the visitbonus of 1000 to a random city
 	 */
	void setVisitingBonus(Connection conn) throws SQLException {
	try{
			PreparedStatement ps;
            ps = conn.prepareStatement("UPDATE rancity" +
                   "SET visitbonus = 2000 " +
                   "FROM (SELECT * FROM cities ORDER BY RANDOM LIMIT 1) AS rancity");
            ps.executeUpdate();
        }catch(SQLException e){
            //LET'S HOPE WE DON'T GET HERE
            System.out.println(e.getMessage());
        }
	}

	/* This function should print the winner of the game based on the currently highest budget.
 	 */
	void announceWinner(Connection conn) throws SQLException {
		try{
			PreparedStatement ps;
            ps = conn.prepareStatement("SELECT * FROM persons" +
                   "ORDER BY budget DESC" +
                   "LIMIT 1");
            ResultSet rs = ps.executeQuery();
            rs.next();
            

            System.out.println("The winner is the person with personnummer : "
                    + rs.getString("personnummer") + 
                    " And living in : " + 
                    rs.getString("country")); 
        }catch(SQLException e){
            System.out.prinln(e.getMessage());
            System.out.println("No Winner fuck you");
        }	
    }

	void play (String worldfile) throws IOException {

		// Read username and password from config.cfg
		try {
			BufferedReader nf = new BufferedReader(new FileReader("config.cfg"));
			String line;
			if ((line = nf.readLine()) != null) {
				USERNAME = line;
			}
			if ((line = nf.readLine()) != null) {
				PASSWORD = line;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		if (USERNAME.equals("USERNAME") || PASSWORD.equals("PASSWORD")) {
			System.out.println("CONFIG FILE HAS WRONG FORMAT");
			return;
		}

		try {
			try {
				Class.forName("org.postgresql.Driver");
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			String url = "jdbc:postgresql://ate.ita.chalmers.se/";
			Properties props = new Properties();
			props.setProperty("user",USERNAME);
			props.setProperty("password",PASSWORD);

			final Connection conn = DriverManager.getConnection(url, props);

			/* This block creates the government entry and the necessary
			 * country and area for that.
			 */
			try {
				PreparedStatement statement = conn.prepareStatement("INSERT INTO Countries (name) VALUES (?)");
				statement.setString(1, "");
				statement.executeUpdate();
				statement = conn.prepareStatement("INSERT INTO Areas (country, name, population) VALUES (?, ?, cast(? as INT))");
				statement.setString(1, "");
				statement.setString(2, "");
				statement.setString(3, "1");
				statement.executeUpdate();
				statement = conn.prepareStatement("INSERT INTO Persons (country, personnummer, name, locationcountry, locationarea, budget) VALUES (?, ?, ?, ?, ?, cast(? as NUMERIC))");
				statement.setString(1, "");
				statement.setString(2, "");
				statement.setString(3, "Government");
				statement.setString(4, "");
				statement.setString(5, "");
				statement.setString(6, "0");
				statement.executeUpdate();
			} catch (SQLException e) {
				System.out.println(e.getMessage());
			}

			// Initialize the database from the worldfile
			try {
				BufferedReader br = new BufferedReader(new FileReader(worldfile));
				String line;
				while ((line = br.readLine()) != null) {
				String[] cmd = line.split(" +");
					if ("ROAD".equals(cmd[0]) && (cmd.length == 5)) {
						insertRoad(conn, cmd[1], cmd[2], cmd[3], cmd[4]);
					} else if ("TOWN".equals(cmd[0]) && (cmd.length == 4)) {
						/* Create an area and a town entry in the database */
						insertTown(conn, cmd[1], cmd[2], cmd[3]);
					} else if ("CITY".equals(cmd[0]) && (cmd.length == 4)) {
						/* Create an area and a city entry in the database */
						insertCity(conn, cmd[1], cmd[2], cmd[3]);
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}

			ArrayList<Player> players = new ArrayList<Player>();

			while(true) {
				optionssetup();
				String mode = readLine("? > ");
				String[] cmd = mode.split(" +");
				cmd[0] = cmd[0].toLowerCase();
				if ("new player".startsWith(cmd[0]) && (cmd.length == 5)) {
					Player nextplayer = new Player(cmd[1], cmd[2], cmd[3], cmd[4]);
					if (createPlayer(conn, nextplayer) == 1) {
						players.add(nextplayer);
					}
				} else if ("done".startsWith(cmd[0]) && (cmd.length == 1)) {
					break;
				} else {
					System.out.println("\nInvalid option.");
				}
			}

			System.out.println("\nGL HF!");
			int roundcounter = 1;
			int maxrounds = 5;
			while(roundcounter <= maxrounds) {
				System.out.println("\nWe are starting the " + roundcounter + ". round!!!");
				/* for each player from the playerlist */
				for (int i = 0; i < players.size(); ++i) {
					System.out.println("\nIt's your turn " + players.get(i).playername + "!");
					System.out.println("You are currently located in " + getCurrentArea(conn, players.get(i)) + " (" + getCurrentCountry(conn, players.get(i)) + ")");
					while (true) {
						options();
						String mode = readLine("? > ");
						String[] cmd = mode.split(" +");
						cmd[0] = cmd[0].toLowerCase();
						if ("next moves".startsWith(cmd[0]) && (cmd.length == 1 || cmd.length == 3)) {
							/* Show next moves from a location or current location. Turn continues. */
							if (cmd.length == 1) {
								String area = getCurrentArea(conn, players.get(i));
								String country = getCurrentCountry(conn, players.get(i));
								getNextMoves(conn, players.get(i));
							} else {
								getNextMoves(conn, players.get(i), cmd[1], cmd[2]);
							}
						} else if ("list properties".startsWith(cmd[0]) && (cmd.length == 1 || cmd.length == 3)) {
							/* List properties of a player. Can be a specified player
							   or the player himself. Turn continues. */
							if (cmd.length == 1) {
								listProperties(conn, players.get(i));
							} else {
								listProperties(conn, cmd[1], cmd[2]);
							}
						} else if ("scores".startsWith(cmd[0]) && cmd.length == 1) {
							/* Show scores for all players. Turn continues. */
							showScores(conn);
						} else if ("players".startsWith(cmd[0]) && cmd.length == 1) {
							/* Show scores for all players. Turn continues. */
							System.out.println("\nPlayers:");
							for (int k = 0; k < players.size(); ++k) {
								System.out.println("\t" + players.get(k).playername + ": " + players.get(k).personnummer + " (" + players.get(k).country + ") ");
							}
						} else if ("refund".startsWith(cmd[0]) && (cmd.length == 3 || cmd.length == 5)) {
							if (cmd.length == 5) {
								/* Sell road from arguments. If no road was sold the turn
								   continues. Otherwise the turn ends. */
								if (sellRoad(conn, players.get(i), cmd[1], cmd[2], cmd[3], cmd[4]) == 1) {
									break;
								} else {
									System.out.println("\nTry something else.");
								}
							} else {
								/* Sell hotel from arguments. If no hotel was sold the turn
								   continues. Otherwise the turn ends. */
								if (sellHotel(conn, players.get(i), cmd[1], cmd[2]) == 1) {
									break;
								} else {
									System.out.println("\nTry something else.");
								}
							}
						} else if ("buy".startsWith(cmd[0]) && (cmd.length == 4 || cmd.length == 5)) {
							if (cmd.length == 5) {
								/* Buy road from arguments. If no road was bought the turn
								   continues. Otherwise the turn ends. */
								if (buyRoad(conn, players.get(i), cmd[1], cmd[2], cmd[3], cmd[4]) == 1) {
									break;
								} else {
									System.out.println("\nTry something else.");
								}
							} else {
								/* Buy hotel from arguments. If no hotel was bought the turn
								   continues. Otherwise the turn ends. */
								if (buyHotel(conn, players.get(i), cmd[1], cmd[2], cmd[3]) == 1) {
									break;
								} else {
									System.out.println("\nTry something else.");
								}
							}
						} else if ("move".startsWith(cmd[0]) && cmd.length == 3) {
							/* Change the location of the player to the area from the arguments.
							   If the move was legal the turn ends. Otherwise the turn continues. */
							if (changeLocation(conn, players.get(i), cmd[1], cmd[2]) == 1) {
								break;
							} else {
								System.out.println("\nTry something else.");
							}
						} else if ("quit".startsWith(cmd[0]) && cmd.length == 1) {
							/* End the move of the player without any action */
							break;
						} else {
							System.out.println("\nYou chose an invalid option. Try again.");
						}
					}
				}
				setVisitingBonus(conn);
				++roundcounter;
			}
			announceWinner(conn);
			System.out.println("\nGG!\n");

			conn.close();
		} catch (SQLException e) {
			System.err.println(e);
			System.exit(2);
		}
	}

	private String readLine(String s) throws IOException {
		System.out.print(s);
		BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
		char c;
		StringBuilder stringBuilder = new StringBuilder();
		do {
			c = (char) bufferedReader.read();
			stringBuilder.append(c);
		} while(String.valueOf(c).matches(".")); // Without the DOTALL switch, the dot in a java regex matches all characters except newlines

		System.out.println("");
		stringBuilder.deleteCharAt(stringBuilder.length()-1);

		return stringBuilder.toString();
	}

	/* main: parses the input commands.
 	* /!\ You don't need to change this function! */
	public static void main(String[] args) throws Exception
	{
		String worldfile = args[0];
		Game g = new Game();
		g.play(worldfile);
	}
}

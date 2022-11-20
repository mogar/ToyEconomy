/*
Toy Economy
By Morgan Redfield
10 June 2010

This toy economy contains 8 agents. There is some likelihood that at any
given time step two of the agents will make some kind of resource exchange.
That exchange can take a number of forms. 

There is also a possibility that one of the agents will become an entrepreneur.
This gives them the possibility of gaining a large amount of money, but there
is a risk of losing some amount of their current reserve.

The program will run through 600 time steps, graphing the agents savings over
time. At the end of time, a picture will be saved. Five run-throughs are 
performed.
*/

String filename = "toyEconomy-##";
float exchange_prob = 1; //likelihood of an exchange
float richer_wins = .5; //likelihood of richer person winning

/*
economy_type determines the maximum amount that the winner can take
0 means the winner can take as much as the minimum either agent owns
1 means the winner can take as much as the loser already has
2 means the winner can take as much as both agents combined have
*/
int economy_type = 2;

int rainy_day_savings = 0; //one if people save money

float startup_prob = 0; //likelihood of an agent starting a company
float startup_success = .4; //likelihood of company's success
float startup_gain = 1; //possible amount gained (multiple of already owned)
float startup_lost = .4; //amount that could be lost (fraction of already owned)


void setup() {
 size(900, 600);
}

int runthroughs = 0;

void draw() {
  runthroughs++;
  
  //reset all agents
  background(200);
  float[] accounts = new float[8];
  for (int i = 0; i < accounts.length; i++) {
    accounts[i] = 20; 
  }
  
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < accounts.length; j++) {   
        line( 100*(j+1) - accounts[j]/2, i, 100*(j+1) + accounts[j]/2, i);
    }
  
  if (random(1) < exchange_prob) {
    
    //select two random accounts
    int rich;
    int poor;
    int a = int(random(accounts.length));
    int b = int(random(accounts.length));
    if (accounts[a] > accounts[b]) {
      rich = a;
      poor = b; 
    } else {
      rich = b;
      poor = a; 
    }
    
    int winner;
    int loser;
    if (random(1) < richer_wins) {
      winner = rich;
      loser = poor;
    } else {
      winner = poor;
      loser = rich; 
    }
    
    float delta;
    switch (economy_type) {
      case (0): //most gained is min owned
         delta = random(min(accounts[winner], accounts[loser]));
         accounts[winner] = accounts[winner] + delta;
         accounts[loser] = accounts[loser] - delta;
         break;
      case (1): //loser can lose it all (even if they own more)
         delta = random(accounts[loser]);
         accounts[winner] = accounts[winner] + delta;
         accounts[loser] = accounts[loser] - delta;
         break;
      case (2): //random split of total
         float total = accounts[winner] + accounts[loser];
         delta = random(total);
         accounts[winner] = delta;
         accounts[loser] = total - delta;
         break;
      default:
         break;
    }
  }

  if (rainy_day_savings == 1) {
    for (int j = 0; j < accounts.length; j++) {   
        accounts[j] += 1; //rainy day savings
    }
    int d = int(random(accounts.length));
    if (accounts[d] > 8) {
      accounts[d] -= 8; 
    } else {
      accounts[d] = 1;
    }
  }

  if (random(1) < startup_prob) {
    //add an entrepreneur
    int c = int(random(accounts.length));
    float gained = random(startup_gain*accounts[c]);
    if (random(1) < startup_success) {
     accounts[c] += gained; 
    } else {
     accounts[c] = accounts[c] - random(startup_lost*accounts[c]); 
    }
  }
  }
  
  if (runthroughs == 5) {
    noLoop();
  }
  saveFrame(filename);
}

#include <iostream>
#include <fstream>
#include <cstdio>
using namespace std;

int costs[4][4];
int robots[4], resources[4];
int max_geodes;
int robot_order[40], n_robots;
long long prints = 0;

void generate(int minute, int last_robot = 1) {
  // ++prints;
  // if (prints % 10000000 == 0) {
  //   cout << minute << endl;
  //   for (int i = 1; i <= n_robots; ++i)
  //     cout << robot_order[i] << " ";
  //   cout << endl;
  // }
  max_geodes = max(max_geodes, resources[3]);
  if (minute == 25) {
    return;
  }
  int c_robots[4]; 
  for (int j = 0; j < 4; ++j) {
    c_robots[j] = robots[j];
  }
  int generated = 0;
  int start = max(0, last_robot - 1), end = min(last_robot + 1, 3);
  if (n_robots > 2 && robot_order[n_robots] == robot_order[n_robots - 1] && robot_order[n_robots] == robot_order[n_robots - 2]) {
    start = last_robot;
  }
  for (int next_robot = start; next_robot <= end; ++next_robot) {
    int ok = 1;
    for (int i = 0; i < next_robot; ++i) {
      if (!robots[i]) ok = 0;
    }
    if (ok && (robots[next_robot] < max(max(costs[0][next_robot], costs[1][next_robot]), max(costs[2][next_robot], costs[3][next_robot])) || next_robot == 3)
      && resources[0] >= costs[next_robot][0] 
      && resources[1] >= costs[next_robot][1] 
      && resources[2] >= costs[next_robot][2] 
      && resources[3] >= costs[next_robot][3]) {
        ++generated;
        resources[0] -= costs[next_robot][0];
        resources[1] -= costs[next_robot][1];
        resources[2] -= costs[next_robot][2];
        resources[3] -= costs[next_robot][3];
        ++robots[next_robot];
        robot_order[++n_robots] = next_robot;
        for (int j = 0; j < 4; ++j) {
          resources[j] += c_robots[j];
        }
        generate(minute + 1, next_robot);
        --n_robots;
        --robots[next_robot];
        resources[0] += costs[next_robot][0];
        resources[1] += costs[next_robot][1];
        resources[2] += costs[next_robot][2];
        resources[3] += costs[next_robot][3];
        for (int j = 0; j < 4; ++j) {
          resources[j] -= c_robots[j];
        }
      }
  }
  if (generated < end - start + 1) {
    for (int j = 0; j < 4; ++j) {
      resources[j] += c_robots[j];
    }
    generate(minute + 1, last_robot);
    for (int j = 0; j < 4; ++j) {
      resources[j] -= c_robots[j];
    }
  }
}

int main() {
  int res = 0;
  char blueprint_string[300];
  ifstream fin("day19.txt");
  while(fin.getline(blueprint_string, 300)) {
    int idx = 0;
    max_geodes = 0;
    sscanf(blueprint_string, "Blueprint %d: Each ore robot costs %d ore. Each clay robot costs %d ore. Each obsidian robot costs %d ore and %d clay. Each geode robot costs %d ore and %d obsidian.", 
      &idx, &costs[0][0], &costs[1][0], &costs[2][0], &costs[2][1], &costs[3][0], &costs[3][2]);
    robots[0] = robots[1] = robots[2] = robots[3] = 0;
    resources[0] = resources[1] = resources[2] = resources[3] = 0;
    robots[0] = 1;
    n_robots = 0;
    generate(1);
    cout << "Geodes: " << max_geodes << "\n"; cout.flush();
    res += idx * max_geodes;
  }
  cout << res;
}
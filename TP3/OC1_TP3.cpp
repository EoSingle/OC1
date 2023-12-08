#include <iostream>
#include <vector>
#include <iomanip>
#include <sstream>
#include <fstream>

using namespace std;

struct CacheLine {
    bool valid;      //indicates whether the line contains valid data
    uint32_t blockId; //identifier of the block stored in the line
};

//extracts the block identifier from address bits
uint32_t extractBlockId(uint32_t address, int blockSize) {
    return address & ~(blockSize - 1);
}

int main() {
    //input parameters
    int cacheSize, lineSize, groupSize;

    //requests simulation parameters from the user
    cout << "Total cache size (in bytes): ";
    cin >> cacheSize;
    cout << "Size of each line (in bytes): ";
    cin >> lineSize;
    cout << "Size of each group: ";
    cin >> groupSize;

    //number of lines in the cache
    int numLines = cacheSize / lineSize;

    //initializes the cache as a vector of vectors of CacheLine
    vector<vector<CacheLine>> cache(numLines / groupSize, vector<CacheLine>(groupSize));

    //hit and miss
    int hits = 0;
    int misses = 0;

    //creates and opens the output file
    ofstream outputFile("output.txt");

    //TEST! Reads memory manually from the terminal
    //MUST MODIFY BEFORE SUBMITTING
    cout << "Enter memory accesses in hexadecimal (type 'x' to exit):" << endl;
    string input;
    while (cin >> input && input != "x") {
        uint32_t address;
        stringstream ss;
        //converts hexadecimal value to decimal
        ss << hex << input;
        ss >> address;

        //group index
        int groupIndex = (address / lineSize) % (numLines / groupSize);

        //extracts block identifier
        uint32_t blockId = extractBlockId(address, lineSize);

        //checks if the block is in the cache
        bool found = false;
        for (int i = 0; i < groupSize; i++) {
            if (cache[groupIndex][i].valid && cache[groupIndex][i].blockId == blockId) {
                found = true;
                hits++;
                break;
            }
        }
        //if  block is not found we have a miss
        if (!found) {
            misses++;
            // Find the first empty line or apply the replacement policy (FIFO)
            int replaceIndex = 0;
            for (int i = 0; i < groupSize; ++i) {
                if (!cache[groupIndex][i].valid) {
                    replaceIndex = i;
                    break;
                }
            }
            //updates the cache line with the new data
            cache[groupIndex][replaceIndex].valid = true;
            cache[groupIndex][replaceIndex].blockId = blockId;
        }

        //prints the cache state after each access to the output file
        outputFile << "================" << endl;
        outputFile << "IDX V ** ADDR **" << endl;
        for (int i = 0; i < groupSize; i++) {
            int index = groupIndex * groupSize + i;
            uint32_t blockIdOutput = cache[groupIndex][i].valid ? cache[groupIndex][i].blockId & 0xFFFFFC00 : 0;
            outputFile << setw(3) << setfill('0') << index << " "
                       << cache[groupIndex][i].valid << " "
                       << "0x" << hex << setw(8) << setfill('0') << blockIdOutput << endl;
        }
    }

    //prints the count of hits and misses at the end to the output file
    outputFile << "#hits: " << hits << endl;
    outputFile << "#miss: " << misses << endl;

    outputFile.close();

    return 0;
}
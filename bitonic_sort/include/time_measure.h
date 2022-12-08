#include <chrono>
#include <fstream>
#include <string>

namespace time_measure{
class Timer{
    private:
    std::chrono::system_clock::time_point startTime, currentTime;
    int count;
    std::ofstream outputFile;
    std::string outputFileName = "time_measure.log";
    public:
    Timer();
    ~Timer();
    void start();
    void stop();
};
}

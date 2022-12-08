#include <chrono>
#include <fstream>
#include <string>
#include <map>

namespace time_measure{
class TimerInfo{
    private:
    int count;
    double time;

    public:
    void init();
    void add(const double& result);
    std::string result();
};
class Timer{
    private:
    std::chrono::system_clock::time_point startTime, currentTime;
    std::ofstream outputFile;
    std::string outputFileName = "time_measure.log";
    std::map<std::string, TimerInfo> timerList;
    public:
    Timer();
    ~Timer();
    void start();
    void stop(const std::string& str);
};
}

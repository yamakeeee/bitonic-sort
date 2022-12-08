#include <iostream>

#include "time_measure.h"

namespace time_measure{

void TimerInfo::add(const double& result){
    this->count += 1;
    this->time += result;
}

void TimerInfo::init(){
    this->count = 0;
    this->time = 0.0;
}

std::string TimerInfo::result(){
    std::string res = "count, sum, average = ";
    res += std::to_string(count) + ", " + std::to_string(time) + " ms, "
        + std::to_string(time / count) + " ms";
    return res;
}

Timer::Timer(){
}

Timer::~Timer(){
    outputFile.open(outputFileName);
    if(!outputFile){
        std::cerr << "cannot open file" << std::endl;
        exit(0);
    }
    for(auto& timerData:timerList){
        outputFile << timerData.first << ": " <<
        timerData.second.result() << "\n";
    }
    outputFile.close();
    return;
}

void Timer::start(){
    startTime = std::chrono::system_clock::now();
}

void Timer::stop(const std::string& str){
    currentTime = std::chrono::system_clock::now();
    double time = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - startTime).count();
    if(timerList.find(str) == timerList.end()){
        timerList[str].init();
    }
    timerList[str].add(time);
}

}

#include <iostream>

#include "time_measure.h"

namespace time_measure{

Timer::Timer():count(0){
    outputFile.open(outputFileName);
    if(!outputFile){
        std::cerr << "cannot open file" << std::endl;
        exit(0);
    }
}

Timer::~Timer(){
    outputFile.close();
    return;
}

void Timer::start(){
    startTime = std::chrono::system_clock::now();
}

void Timer::stop(){
    currentTime = std::chrono::system_clock::now();
    double time = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - startTime).count();
    outputFile << count++ << ": " << time << " ms\n";
}

}

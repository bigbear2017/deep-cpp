# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

CXX=g++
CPPEX_SRC = $(wildcard *.cpp)
CPPEX_EXE = $(patsubst %.cpp, %, $(CPPEX_SRC))

CFLAGS += -I./include/nnvm/include -I./include/dmlc-core/include
CPPEX_CFLAGS += -I./include
CFLAGS+= `pkg-config --cflags opencv`
LDFLAGS+=`pkg-config --libs opencv`
LDFLAGS+= lib/libmxnet.so
CPPEX_EXTRA_LDFLAGS := -L./lib -lmxnet

.PHONY: all image-classification-predict clean

all: $(CPPEX_EXE)

$(CPPEX_EXE):% : %.cpp ./lib/libmxnet.so ./include/mxnet-cpp/*.h
	$(CXX) -std=c++0x $(CFLAGS) $(CPPEX_CFLAGS) -o $@ $(filter %.cpp %.a, $^) $(CPPEX_EXTRA_LDFLAGS)

image-classification-predict: image-classification-predict.o
	g++ -O3 -o image-classification-predict image-classification-predict.o $(LDFLAGS)

image-classification-predict.o: image-classification-predict.cpp
	g++ -O3 $(CPPEX_CFLAGS)  -c image-classification-predict.cpp ${CFLAGS}
clean:
	rm -f $(CPPEX_EXE) *.o

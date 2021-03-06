# Spécialement pour ArRay_
# $$DATE$$ : jeu. 08 février 2018 (09:43:16)

dumb_objs:=$(patsubst %.c,%.o,$(wildcard dumb/src/it/*.c))
dumb_objs+=$(patsubst %.c,%.o,$(wildcard dumb/src/core/*.c))
dumb_objs+=$(patsubst %.c,%.o,$(wildcard dumb/src/helpers/*.c))

dmp_sources=libdmp.cpp dumb_with_openal.cpp
dmp_objs=$(dmp_sources:.cpp=.o)

all: dumb_fPIC.a libdmp.so test_without_lua.exe
	@echo "all done !"

test_without_lua.exe: dumb_with_openal.cpp
	@g++ $< dumb_fPIC.a -lopenal -Idumb/include -o $@ -DTEST_JSEB
	@rm -f dumb_with_openal.o
	@echo $@ done

dumb_fPIC.a: $(dumb_objs)
	@ar cr $@ $(dumb_objs)
	@echo $@ done

libdmp.so: $(dmp_objs)
	@g++ $(dmp_objs) dumb_fPIC.a -llua -lopenal -shared -o libdmp.so
	@echo $@ done

%.o: %.c
	@echo $<
	@gcc $< -c -o $@ -fPIC -Idumb/include

%.o: %.cpp
	@g++ -fvisibility=hidden -fPIC -shared -Wall -W -Idumb/include -c $<

clean:
	@rm -f *.o
	@find dumb/src -iname "*.o" -delete
	@rm -f dumb_fPIC.a libdmp.so
	@echo "cleaning is my business… and business is good."

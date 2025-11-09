#ifndef CATCH_MAIN
#define CATCH_MAIN

#define CATCH_CONFIG_RUNNER
#include <catch2/catch_all.hpp>

int main(int argc, char *argv[])
{
    Catch::Session session;
    return session.run(argc, argv);
}

#endif // CATCH_MAIN

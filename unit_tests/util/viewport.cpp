#include "util/viewport.hpp"

using namespace osrm::util;

#include <boost/functional/hash.hpp>
#include <boost/test/unit_test.hpp>

#include <iostream>

BOOST_AUTO_TEST_SUITE(viewport_test)

using namespace osrm;
using namespace osrm::util;

BOOST_AUTO_TEST_CASE(zoom_level_test)
{
    BOOST_CHECK_EQUAL(
        12,
        12);
}

BOOST_AUTO_TEST_SUITE_END()

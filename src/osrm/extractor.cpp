#include "osrm/extractor.hpp"
#include "extractor/extractor.hpp"
#include "extractor/extractor_config.hpp"
#include "extractor/scripting_environment_lua.hpp"
#include <iostream>

namespace osrm
{

// Pimpl-like facade

void extract(const extractor::ExtractorConfig &config)
{

    std::cout << config.profile_path.string() << std::endl;
    // extractor::Sol2ScriptingEnvironment scripting_environment(config.profile_path.string(),
    //                                                           config.location_dependent_data_paths);
    // extractor::Extractor(config).run(scripting_environment);
}

} // namespace osrm

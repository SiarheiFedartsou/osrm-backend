#include "storage/io_config.hpp"

#include "util/log.hpp"

#include <filesystem>
#include <filesystem>
#include <filesystem>

namespace osrm
{
namespace storage
{
bool IOConfig::IsValid() const
{
    namespace fs = std::filesystem;

    bool success = true;
    for (auto &fileName : required_input_files)
    {
        if (!fs::is_regular_file(fs::status(base_path.string() + fileName.string())))
        {
            util::Log(logWARNING) << "Missing/Broken File: " << base_path.string()
                                  << fileName.string();
            success = false;
        }
    }
    return success;
}
} // namespace storage
} // namespace osrm

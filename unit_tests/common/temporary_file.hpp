#ifndef UNIT_TESTS_TEMPORARY_FILE_HPP
#define UNIT_TESTS_TEMPORARY_FILE_HPP

#include <filesystem>

struct TemporaryFile
{
    TemporaryFile() : path(std::filesystem::unique_path()) {}
    TemporaryFile(const std::string &path) : path(path) {}

    ~TemporaryFile() { std::filesystem::remove(path); }

    std::filesystem::path path;
};

#endif // UNIT_TESTS_TEMPORARY_FILE_HPP

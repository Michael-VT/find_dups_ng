# find_dups Usage Guide

## Quick Start

### 1. Choose Your Implementation

Select the implementation that best fits your needs:

| For Best... | Use | Why |
|-------------|-----|-----|
| **Overall Performance** | **Rust** | Fastest, memory-safe, great for large datasets |
| **Portability** | **Go** | Single static binary, no dependencies |
| **Quick Prototyping** | **Python** | Easy to modify, no compilation needed |
| **Production Servers** | **Go** or **Rust** | Reliable, efficient, production-ready |
| **JavaScript Projects** | **Bun** or **Node.js** | Native integration with JS ecosystem |
| **Maximum Speed** | **C++** | Best raw performance (requires OpenSSL) |

### 2. Basic Usage

```bash
# Scan a single directory
./find_dups /path/to/directory

# Scan multiple directories
./find_dups /path/to/dir1 /path/to/dir2 /path/to/external/drive

# With Go (after building)
cd find_dups_go && go build -o find_dups find_dups.go
./find_dups ~/Documents ~/Downloads

# With Python (no build needed)
python3 find_dups_python/find_dups.py ~/Documents ~/Downloads

# With Rust (after building)
cd find_dups_rust && cargo build --release
./target/release/find_dups ~/Documents ~/Downloads
```

### 3. Understanding the Output

After scanning, you'll get these files:

- **duplicates_<lang>.csv** - All duplicate files with metadata
- **sort_dup_<lang>.csv** - All files sorted by size (largest first)
- **analytics_<lang>.json** - Detailed statistics by file type
- **duprm_<lang>.sh** - Deletion script (review before running!)

### 4. Reviewing Duplicates

```bash
# View duplicates
cat duplicates_go.csv | less

# View largest duplicates
head -20 sort_dup_go.csv

# View analytics
cat analytics_go.json | jq '.by_category'
```

### 5. Safe Deletion

**⚠️ ALWAYS REVIEW THE SCRIPT FIRST!**

```bash
# 1. Review what will be deleted
cat duprm_go.sh | less

# 2. Dry-run (first few lines)
head -20 duprm_go.sh

# 3. Execute if satisfied
./duprm_go.sh
```

## Common Use Cases

### Backup Consolidation

Find and remove duplicates across multiple backup drives:

```bash
# Scan all backup drives
./find_dups /mnt/backup1 /mnt/backup2 /mnt/backup3

# Review results
cat duplicates_go.csv

# Execute deletion after verification
./duprm_go.sh
```

### Project Cleanup

Find duplicate source files across projects:

```bash
# Scan embedded projects
./find_dups ~/projects/embedded/project1 \
            ~/projects/embedded/project2 \
            ~/projects/common

# Check for duplicate libraries
cat analytics_go.json | jq '.by_category.source'
```

### Migration Verification

Verify all files were copied after migration:

```bash
# Scan source and destination
./find_dups /old/drive /new/drive

# All files should appear in duplicates (1:1 match)
wc -l duplicates_go.csv
```

### Disk Space Recovery

Find large duplicates to reclaim space:

```bash
# Scan media directories
./find_dups ~/Pictures ~/Videos ~/Music

# View largest space wasters
head -50 sort_dup_go.csv

# Check potential savings
cat analytics_go.json | jq '.summary.recoverable_bytes'
```

## Advanced Usage

### Cross-Drive Scanning

Scan files across different mount points:

```bash
# Internal SSD + External USB + Network Share
./find_dups ~/Documents \
            /Volumes/ExternalDrive \
            /mnt/nas/share
```

### Filtering by File Type

Use analytics to focus on specific categories:

```bash
# Run scan
./find_dups ~/Documents

# Extract duplicate PDFs
cat analytics_go.json | jq '.by_category.docs'

# Find duplicate images
cat analytics_go.json | jq '.by_category.image'
```

### Automated Cleanup

For automated workflows (use with caution):

```bash
# Generate script, review, then execute
./find_dups /path/to/scan
# ... review duprm_go.sh ...
./duprm_go.sh
```

## Performance Tips

### For Large Scans (100K+ files)

1. **Use Rust or Go** - 2-3x faster than Python/JS
2. **Use local storage** - Network drives slow hashing significantly
3. **Exclude system directories** - Add to implementation if needed
4. **Run during off-hours** - Minimize impact on other work

### For Maximum Speed

```bash
# Rust is fastest for large datasets
cd find_dups_rust
cargo build --release
./target/release/find_dups /path/to/scan

# C++ with OpenSSL is also very fast
cd find_dups_cp
g++ -std=c++17 -O3 -pthread find_dups.cpp -o find_dups_cpp -lcrypto
./find_dups_cpp /path/to/scan
```

### For Quick Scans

```bash
# Python is fastest for small datasets (<10K files)
python3 find_dups_python/find_dups.py /path/to/scan
```

## Troubleshooting

### "Permission denied" errors

These are suppressed by default. The tool skips inaccessible files.

### "Too many open files" error

Increase the limit:

```bash
ulimit -n 4096  # or higher
```

### Out of memory

For extremely large datasets (1M+ files):

- Use Rust or Go (most memory-efficient)
- Process directories separately
- Add more RAM to your system

### Incorrect results

If results look wrong:

1. Check file system for corruption
2. Verify disk integrity
3. Run with verbose logging (add to implementation)

## Security Considerations

### Safe Deletion

The tool generates a deletion script for review:

```bash
# ALWAYS review before executing
cat duprm_go.sh
# ... verify paths ...
./duprm_go.sh
```

### No Backdoors

All implementations are:

- ✅ Open source (MIT license)
- ✅ No network connections
- ✅ No data transmission
- ✅ SHA-256 cryptographic hashing
- ✅ Verifiable builds (checksums provided)

### Source Verification

Verify your build matches official binaries:

```bash
# Generate checksums
make check-sums

# Compare with published checksums (when available)
cat .checksums/rust.txt
```

## Integration with Other Tools

### With find

```bash
# Find and process specific file types
find ~/Documents -name "*.pdf" -exec ./find_dups {} \;
```

### With rsync

After finding duplicates:

```bash
# Keep newest, delete old
# (manual inspection required)
```

### With backup tools

```bash
# Before backup, remove duplicates
./find_dups ~/Documents
./duprm_go.sh
# Now run backup
rsync -av ~/Documents/ /backup/destination/
```

## Best Practices

1. **Always test on small directories first**
2. **Review the deletion script before execution**
3. **Keep backups until you're sure**
4. **Run multiple scans for large datasets**
5. **Use the most appropriate implementation for your needs**
6. **Verify results with analytics output**
7. **Document your cleanup process**

## Getting Help

- Review test cases in `tests/` directory
- Check README.md for implementation details
- View source code - it's well documented
- Run smoke tests: `make test`

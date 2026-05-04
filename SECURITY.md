# Security Policy

## Backdoor-Free Guarantee

This project is designed with **security and transparency** as core principles:

### ✅ No Network Activity

All implementations:
- **Never make network connections**
- **Never transmit data externally**
- **Never contact remote servers**
- **Work completely offline**

Verification:
```bash
# Check for network syscalls (Linux)
strace -e trace=network ./find_dups /path/to/scan 2>&1 | grep -i socket
# Should output nothing

# Or use lsof to check network connections
lsof -p $(pgrep find_dups) -i -a
# Should show no network connections
```

### ✅ No Data Exfiltration

All implementations:
- **Only read local files**
- **Only write local output files** (CSV, JSON, shell script)
- **Never access sensitive system areas**
- **Never modify system files** (except output files)

Verification:
```bash
# Monitor file system access
inotifywait -m -r . | grep find_dups
# Should only show access to scanned directories and output files
```

### ✅ Transparent Hashing

All implementations use **standard SHA-256**:

- **Go**: `crypto/sha256` (standard library)
- **Python**: `hashlib.sha256()` (standard library)
- **Rust**: `sha2::Sha256` (well-known crate)
- **JavaScript**: `crypto.createHash('sha256')` (standard library)
- **C++**: `EVP_sha256()` (OpenSSL)

No custom or proprietary hashing algorithms.

### ✅ Source Code Verification

The entire source code is:
- **MIT Licensed** - Free to use, modify, distribute
- **Readable** - Well-commented and clear
- **Auditable** - No obfuscation or minification
- **Testable** - Comprehensive test suite

### ✅ Reproducible Builds

Build artifacts can be verified:

```bash
# Generate checksums
make check-sums

# Verify against published checksums
sha256sum -c .checksums/*.txt
```

### ✅ No Hidden Dependencies

All dependencies are:
- **Well-known libraries** (OpenSSL, standard libraries)
- **Listed in documentation**
- **Audited by security community**
- **Version-pinned** (Rust/Cargo, Go modules)

## Security Best Practices

### 1. Always Review Before Deletion

The tool generates a **deletion script** - never execute blindly:

```bash
# Review what will be deleted
cat duprm_go.sh | less

# Verify paths look correct
grep "rm" duprm_go.sh | head -20

# Only execute after verification
./duprm_go.sh
```

### 2. Test on Non-Critical Data First

Before running on important data:

```bash
# Create test directory
mkdir test_scan
cp -r sample_data test_scan/

# Run find_dups on test
./find_dups test_scan

# Review results
cat duplicates_go.csv
```

### 3. Keep Backups

Always maintain backups until you're confident:

```bash
# Before deletion
tar czf backup_before_cleanup.tar.gz /path/to/data

# Run find_dups
./find_dups /path/to/data

# Review and execute
./duprm_go.sh

# Keep backup until verified
```

### 4. Run as Regular User

Never run as root unless absolutely necessary:

```bash
# BAD: Don't do this
sudo ./find_dups /

# GOOD: Run as regular user
./find_dups ~/Documents
```

### 5. Verify Checksums

When downloading pre-built binaries:

```bash
# Download binary
wget https://example.com/find_dups_linux_amd64

# Verify checksum
sha256sum -c CHECKSUMS.txt
```

## Known Security Considerations

### File System Access

The tool requires:
- **Read access** to scanned directories
- **Write access** to current directory (for output files)

Limit permissions to minimum required.

### Deletion Script

The generated `duprm_*.sh` script:
- Uses `rm --` to prevent flag injection
- Escapes single quotes in paths
- Is executable by default (for convenience)

**Always review before execution.**

### Resource Usage

Large scans may consume:
- **CPU**: All cores (parallel hashing)
- **Memory**: Depends on file count (~1GB per 100K files)
- **Disk I/O**: High during scanning

Monitor system resources:

```bash
# Monitor CPU usage
top -p $(pgrep find_dups)

# Monitor memory
ps aux | grep find_dups

# Monitor disk I/O
iotop -p $(pgrep find_dups)
```

## Reporting Security Issues

If you discover a security vulnerability:

1. **Do NOT open a public issue**
2. Email details to: [security contact to be added]
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if known)

Response timeframe: **Within 48 hours**

## Auditing the Code

### Self-Audit Checklist

- ✅ No network syscalls
- ✅ No external process execution
- ✅ No dynamic code evaluation
- ✅ No obfuscation
- ✅ Standard cryptographic functions
- ✅ Clear, readable code
- ✅ Comprehensive tests

### Third-Party Audit

We encourage third-party security audits. The code is designed to be:
- **Easy to review** - Clear structure and documentation
- **Easy to test** - Comprehensive test suite
- **Easy to build** - Reproducible builds

## Compliance

### Data Privacy

This tool:
- **Does not collect personal data**
- **Does not transmit data**
- **Does not store data beyond output files**
- **Respects user privacy**

### GDPR Compliance

For GDPR considerations:
- Tool processes data locally
- No data leaves your system
- You maintain full control
- No third-party data processing

## Trust but Verify

We encourage users to:

1. **Review the source code**
2. **Build from source**
3. **Run tests**
4. **Verify checksums**
5. **Monitor system activity**

The tool is designed to be **transparent and auditable**.

## Disclaimer

This tool is provided "as is" without warranty. Users should:
- Test on non-critical data first
- Maintain backups
- Review deletion scripts
- Understand the implications of file deletion

The authors are not responsible for data loss.

## Version History

### Current Version
- ✅ No known security vulnerabilities
- ✅ No backdoors
- ✅ No network activity
- ✅ Transparent SHA-256 hashing

### Future Updates
- All changes will be documented
- Security patches prioritized
- Regular audits encouraged

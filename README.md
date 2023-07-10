# rebuild
Bash script to automatically build with cmake

### Install

```bash
git clone https://github.com/h-burd/rebuild.git
cd rebuild
chmod +x rebuild.sh
sudo mv rebuild.sh /bin/

echo "alias rebuild='/bin/rebuild.sh'" >> ~/.bashrc
source ~/.bashrc
```
### Use
```bash
── program_name
   ├── build
   ├── CMakeLists.txt
   └── main.cpp
```
Run the ```rebuild``` command to compile from CMakeLists.txt. Rebuild can also be run from the build directory.

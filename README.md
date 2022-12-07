## 概要
家の PC に GPU が刺さっていたので、せっかくだし何か並列アルゴリズム実装してみたいよねとなった。  
bitonic sort を実装して、クイックソートと動作時間の比較をしてみたり、Radix Sort を実装してみたりしたい。

## 実行環境
- Windows 11 + WSL2
- Docker: 20.10.21
- GPU: Nvidia GeForce GTX 1660 Super

## 実行手順
### WSL 内
- Docker image を作成
```
docker build -t bitonic-sort .
```
- Docker container を作成
```
docker run -it --gpus=all -v ${PWD}/bitonic_sort:/home/bitonic_sort --name bitonic-sort bitonic-sort
```

### Docker コンテナ内
- ビルド用ディレクトリを作成し、cmake を実行し、ビルドする。[参考](https://qiita.com/osamu0329/items/7de2b190df3cfb4ad0ca)
```
mkdir build
cd build
cmake ..
make
```
- 実行コマンド
```
./main
```

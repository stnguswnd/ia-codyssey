# Codyssey 1주차 - AI/SW 개발 워크스테이션 구축

## 1. 프로젝트 개요

이번 과제에서는 iMac(macOS) 환경에서 OrbStack을 실행한 뒤, 터미널(CLI) 기반으로 개발 워크스테이션을 구성했다.  
터미널 기본 조작, 권한 변경 실습, Docker 설치/점검, 컨테이너 실행, Dockerfile 기반 커스텀 웹 서버 구축, 포트 매핑 검증, bind mount 반영 확인, volume 영속성 검증, Git/GitHub/VSCode 연동까지 수행했다.

---

## 2. 실행 환경

- Host OS: macOS [버전 입력]
- Device: iMac
- Shell: zsh
- Docker Engine: OrbStack
- Docker Version: [docker --version 결과 입력]
- Git Version: [git --version 결과 입력]
- Working Directory: `/Users/[본인계정명]/codyssey-week1`
- GitHub Repository: [여기에 저장소 링크 입력]

---

## 3. 제출물 구성

```text
codyssey-week1/
├─ README.md
├─ Dockerfile
├─ app/
│  └─ index.html
└─ screenshots/
    ├─ port-8080.png
    ├─ bind-before.png
    ├─ bind-after.png
    └─ vscode-github.png
```

---

## 4. 수행 체크리스트

- [x] 터미널 기본 조작 및 폴더 구성
- [x] 파일/디렉토리 권한 변경 실습
- [x] Docker 설치 및 기본 점검
- [x] Docker 기본 명령 수행 (`images`, `ps`, `ps -a`, `logs`, `stats`)
- [x] `hello-world` 실행
- [x] `ubuntu` 컨테이너 내부 명령 실행
- [x] Dockerfile 기반 커스텀 이미지 작성
- [x] 이미지 빌드 및 컨테이너 실행
- [x] 포트 매핑 검증
- [x] Bind Mount 반영 검증
- [x] Volume 영속성 검증
- [x] Git 사용자 설정 및 GitHub/VSCode 연동
- [x] 트러블슈팅 정리
- [x] 민감정보 마스킹 확인

---

## 5. 개념 정리

### 5-1. 절대 경로와 상대 경로

- 절대 경로: `/Users/[본인계정명]/codyssey-week1`
- 상대 경로: `./app`, `../`, `./screenshots`

절대 경로는 루트부터 시작하는 전체 경로이고, 상대 경로는 현재 위치를 기준으로 해석되는 경로다.

### 5-2. 권한 의미 정리

- `r`: read
- `w`: write
- `x`: execute

예시:
- `644` = 소유자 `rw-`, 그룹 `r--`, 기타 사용자 `r--`
- `755` = 소유자 `rwx`, 그룹 `r-x`, 기타 사용자 `r-x`

일반적으로 파일은 `644`, 디렉토리는 `755` 형태로 많이 사용한다.

### 5-3. Git과 GitHub 차이

- Git: 로컬 환경에서 버전 이력을 관리하는 도구
- GitHub: 원격 저장소 및 협업 플랫폼

### 5-4. 포트 매핑이 필요한 이유

컨테이너 내부 웹 서버는 컨테이너 안에서만 열려 있기 때문에, 호스트(macOS) 브라우저에서 접근하려면 `-p 호스트포트:컨테이너포트` 형식으로 연결해줘야 한다.

### 5-5. Bind Mount와 Volume 차이

- Bind Mount: 호스트의 실제 디렉토리를 컨테이너에 직접 연결
- Volume: Docker가 관리하는 별도 영속 저장 공간

---

## 6. 수행 로그

### 6-1. 작업 폴더 생성

#### 실행 명령

```bash
mkdir -p ~/codyssey-week1/app ~/codyssey-week1/screenshots
cd ~/codyssey-week1
touch README.md Dockerfile app/index.html
git init
git branch -M main
```

#### 실행 결과

```text
guswnd0432389@c3r4s3 desktop % mkdir -p ./codyssey-week1/app ./codyssey-week1/screenshots
guswnd0432389@c3r4s3 desktop % cd ~/codyssey-week1
guswnd0432389@c3r4s3 codyssey-week1 % touch README.md Dockerfile app/index.html
git init
git branch -M main

hint: Using 'master' as the name for the initial branch. This default branch name
hint: will change to "main" in Git 3.0. To configure the initial branch name
hint: to use in all of your new repositories, which will suppress this warning,
hint: call:
hint:
hint: 	git config --global init.defaultBranch <name>
hint:
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
`hint: 'development'. The just-created branch can be renamed via this command:
hint:
hint: 	git branch -m <name>
hint:
hint: Disable this message with "git config set advice.defaultBranchName false"`
Initialized empty Git repository in /Users/guswnd0432389/codyssey-week1/.git/

guswnd0432389@c3r4s3 codyssey-week1 % ls
Dockerfile	README.md	app		screenshots
```

---

### 6-2. 터미널 기본 조작

#### 실행 명령

```bash
pwd
ls
ls -la

mkdir practice
cd practice

touch a.txt
echo "hello codyssey" > a.txt
cat a.txt

mkdir dir1
cp a.txt dir1/
mv a.txt b.txt
mv b.txt dir1/c.txt

ls -la
cd ..
rm -r practice
```

#### 실행 결과

```text
guswnd0432389@c3r4s3 codyssey-week1 % pwd 
/Users/guswnd0432389/codyssey-week1

guswnd0432389@c3r4s3 codyssey-week1 % ls
Dockerfile	README.md	app		screenshots

guswnd0432389@c3r4s3 codyssey-week1 % ls -la
total 0
drwxr-xr-x   7 guswnd0432389  guswnd0432389  224 Mar 31 14:41 .
drwxr-x---+ 24 guswnd0432389  guswnd0432389  768 Mar 31 14:44 ..
drwxr-xr-x   9 guswnd0432389  guswnd0432389  288 Mar 31 14:41 .git
-rw-r--r--   1 guswnd0432389  guswnd0432389    0 Mar 31 14:41 Dockerfile
-rw-r--r--   1 guswnd0432389  guswnd0432389    0 Mar 31 14:41 README.md
drwxr-xr-x   3 guswnd0432389  guswnd0432389   96 Mar 31 14:41 app
drwxr-xr-x   2 guswnd0432389  guswnd0432389   64 Mar 31 14:40 screenshots

guswnd0432389@c3r4s3 codyssey-week1 % mkdir practice
guswnd0432389@c3r4s3 codyssey-week1 % cd practice
guswnd0432389@c3r4s3 practice % touch a.txt
guswnd0432389@c3r4s3 practice % echo "hello codyssey" > a.txt

guswnd0432389@c3r4s3 practice % cat a.txt
hello codyssey

guswnd0432389@c3r4s3 practice % mkdir
usage: mkdir [-pv] [-m mode] directory_name ...

guswnd0432389@c3r4s3 practice % mkdir dir1
guswnd0432389@c3r4s3 practice % cp a.txt dir1/
guswnd0432389@c3r4s3 practice % mv a.txt b.txt
guswnd0432389@c3r4s3 practice % mv b.txt dir1/c.txt

guswnd0432389@c3r4s3 practice % ls -la
total 0
drwxr-xr-x  3 guswnd0432389  guswnd0432389   96 Mar 31 14:46 .
drwxr-xr-x  8 guswnd0432389  guswnd0432389  256 Mar 31 14:44 ..
drwxr-xr-x  4 guswnd0432389  guswnd0432389  128 Mar 31 14:46 dir1
guswnd0432389@c3r4s3 practice % cd ..
guswnd0432389@c3r4s3 codyssey-week1 % rm -r practice
```

#### 정리

- `pwd`로 현재 위치 확인
- `ls`, `ls -la`로 일반 파일/숨김 파일 확인
- `mkdir`, `touch`, `cp`, `mv`, `rm`으로 기본 파일 조작 수행
- `cat`으로 파일 내용 확인

---

### 6-3. 권한 변경 실습

#### 실행 명령

```bash
touch perm.txt
mkdir permdir

ls -l
ls -ld permdir

chmod 644 perm.txt
chmod 755 permdir

ls -l
ls -ld permdir
```

#### 실행 결과

```text
[여기에 실제 결과 붙여넣기]
```

#### 정리

- `perm.txt`에는 `644` 권한 적용
- `permdir`에는 `755` 권한 적용
- 파일과 디렉토리는 권한 의미가 다르게 체감됨

---

### 6-4. Docker 설치 및 기본 점검

#### 실행 명령

```bash
docker --version
docker info
```

#### 실행 결과

```text
[여기에 실제 결과 붙여넣기]
```

#### 정리

- OrbStack 실행 후 터미널에서 `docker` 명령이 정상 동작함을 확인
- Docker Engine 연결 상태와 기본 정보 확인

---

### 6-5. Docker 기본 명령 수행

#### 실행 명령

```bash
docker run hello-world
docker images
docker ps -a

docker run --name log-test alpine sh -c "echo hello from container"
docker logs log-test

docker run -d --name stat-test nginx:alpine
docker ps
docker stats --no-stream
docker rm -f stat-test
```

#### 실행 결과

```text
[여기에 실제 결과 붙여넣기]
```

#### 정리

- `hello-world`로 기본 실행 확인
- `docker images`로 이미지 목록 확인
- `docker ps`, `docker ps -a`로 컨테이너 상태 확인
- `docker logs`로 로그 확인
- `docker stats --no-stream`으로 리소스 사용량 확인

---

### 6-6. 컨테이너 실습 (`ubuntu`)

#### 실행 명령

```bash
docker run -it --name ubuntu-test ubuntu bash
```

컨테이너 내부에서:

```bash
ls
pwd
echo "inside container" > /tmp/hello.txt
cat /tmp/hello.txt
exit
```

#### 실행 결과

```text
[여기에 실제 결과 붙여넣기]
```

#### 정리

- 이미지(Image)는 실행 기반이고, 컨테이너(Container)는 실제 실행 인스턴스다.
- 컨테이너 내부 파일시스템은 호스트(macOS)와 분리되어 있다.
- 컨테이너 안에서 생성한 파일은 컨테이너 내부 경로에 존재한다.

---

### 6-7. Dockerfile 기반 커스텀 웹 서버

#### 선택한 베이스 이미지

`nginx:alpine`을 선택했다.

선택 이유:
- 정적 웹 서버 구성에 적합함
- 설정이 단순함
- 이미지 크기가 작아 실습용으로 가볍고 빠름

#### Dockerfile 내용

```dockerfile
FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey-week1-web"
LABEL org.opencontainers.image.description="Codyssey week1 custom nginx image"
ENV APP_ENV=dev
COPY app/ /usr/share/nginx/html/
```

#### 웹 파일 내용 (`app/index.html`)

```html
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Codyssey Week 1</title>
  </head>
  <body>
    <h1>Hello Codyssey</h1>
    <p>Docker custom web server is working on macOS + OrbStack.</p>
  </body>
</html>
```

#### 빌드/실행 명령

```bash
docker build -t codyssey-week1-web:1.0 .
docker run -d --name week1-web -p 8080:80 codyssey-week1-web:1.0
docker ps
docker logs week1-web
curl http://localhost:8080
```

#### 실행 결과

```text
[여기에 실제 결과 붙여넣기]
```

#### 정리

- 기존 웹 서버 이미지를 기반으로 커스텀 이미지를 생성했다.
- `COPY app/ /usr/share/nginx/html/` 로 정적 파일을 컨테이너에 반영했다.
- 빌드 성공 후 컨테이너 실행까지 확인했다.

---

### 6-8. 포트 매핑 검증

#### 실행 명령

```bash
docker run -d --name week1-web -p 8080:80 codyssey-week1-web:1.0
curl http://localhost:8080
```

#### 실행 결과

```text
guswnd0432389@c3r4s3 codyssey-week1 % docker run -p 8080:80 codyssey-week1-web:1.0
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2026/03/31 06:52:56 [notice] 1#1: using the "epoll" event method
2026/03/31 06:52:56 [notice] 1#1: nginx/1.29.7
2026/03/31 06:52:56 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
2026/03/31 06:52:56 [notice] 1#1: OS: Linux 6.17.8-orbstack-00308-g8f9c941121b1
2026/03/31 06:52:56 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 20480:1048576
2026/03/31 06:52:56 [notice] 1#1: start worker processes
2026/03/31 06:52:56 [notice] 1#1: start worker process 29
2026/03/31 06:52:56 [notice] 1#1: start worker process 30
2026/03/31 06:52:56 [notice] 1#1: start worker process 31
2026/03/31 06:52:56 [notice] 1#1: start worker process 32
2026/03/31 06:52:56 [notice] 1#1: start worker process 33
2026/03/31 06:52:56 [notice] 1#1: start worker process 34


```

#### 브라우저 접속 증거

주소창이 보이도록 브라우저에서 `http://localhost:8080` 접속 후 캡처했다.

![port-8080](./screenshots/port-8080.png)

#### 정리

- 호스트 포트 `8080`을 컨테이너 포트 `80`에 연결했다.
- 브라우저와 `curl` 모두에서 접속을 확인했다.

---

### 6-9. Bind Mount 반영 검증

#### 실행 명령

```bash
docker run -d --name bind-test -p 8081:80 \
  -v "$(pwd)/app:/usr/share/nginx/html" \
  nginx:alpine

curl http://localhost:8081
```

이후 `app/index.html` 내용을 수정한 뒤 다시 확인:

```bash
curl http://localhost:8081
```

#### 실행 결과

```text
[여기에 실제 결과 붙여넣기]
```

#### 수정 전 캡처

![bind-before](./screenshots/bind-before.png)

#### 수정 후 캡처

![bind-after](./screenshots/bind-after.png)

#### 정리

- 호스트의 `app/` 디렉토리를 컨테이너 웹 루트에 직접 연결했다.
- 호스트 파일 수정 후 컨테이너 내부 웹 페이지에도 즉시 반영되는 것을 확인했다.

---

### 6-10. Volume 영속성 검증

#### 실행 명령

```bash
docker volume create mydata

docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity
docker exec -it vol-test bash -lc "echo hi > /data/hello.txt && cat /data/hello.txt"

docker rm -f vol-test

docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
docker exec -it vol-test2 bash -lc "cat /data/hello.txt"
```

#### 실행 결과

```text
[여기에 실제 결과 붙여넣기]
```

#### 정리

- `mydata` 볼륨을 생성했다.
- 첫 번째 컨테이너에서 파일 생성 후 컨테이너를 삭제했다.
- 두 번째 컨테이너에서 같은 파일이 유지되는 것을 확인했다.
- 이를 통해 Docker Volume의 영속성을 검증했다.

---

### 6-11. Git / GitHub / VSCode 연동

#### 실행 명령

```bash
git config --global user.name "[본인 이름]"
git config --global user.email "[본인 이메일]"
git config --global init.defaultBranch main
git config --list

git add .
git commit -m "feat: complete codyssey week1"

git remote add origin [여기에 GitHub 저장소 주소]
git push -u origin main
```

#### 실행 결과

```text
[여기에 실제 결과 붙여넣기]
```

#### VSCode / GitHub 연동 증거

![vscode-github](./screenshots/vscode-github.png)

#### 정리

- Git 사용자 정보 및 기본 브랜치를 설정했다.
- 로컬 저장소를 GitHub 원격 저장소와 연결했다.
- VSCode에서 GitHub 로그인 및 저장소 연동 상태를 확인했다.

---

## 7. 검증 방법 요약

| 항목 | 검증 명령 / 방법 | 증거 위치 |
|---|---|---|
| 터미널 기본 조작 | `pwd`, `ls -la`, `mkdir`, `touch`, `cp`, `mv`, `rm`, `cat` | 본 문서 6-2 |
| 권한 변경 | `chmod 644`, `chmod 755`, `ls -l`, `ls -ld` | 본 문서 6-3 |
| Docker 점검 | `docker --version`, `docker info` | 본 문서 6-4 |
| Docker 운영 명령 | `docker images`, `docker ps`, `docker ps -a`, `docker logs`, `docker stats --no-stream` | 본 문서 6-5 |
| 컨테이너 실습 | `docker run hello-world`, `docker run -it ubuntu bash` | 본 문서 6-5, 6-6 |
| Dockerfile 웹 서버 | `docker build`, `docker run` | 본 문서 6-7 |
| 포트 매핑 | `curl http://localhost:8080` + 브라우저 캡처 | 본 문서 6-8, `screenshots/port-8080.png` |
| Bind Mount | 파일 수정 전/후 비교 | 본 문서 6-9, `screenshots/bind-before.png`, `screenshots/bind-after.png` |
| Volume 영속성 | 컨테이너 삭제 전/후 같은 파일 조회 | 본 문서 6-10 |
| Git/GitHub/VSCode | `git config --list`, `git push`, VSCode 캡처 | 본 문서 6-11, `screenshots/vscode-github.png` |

---

## 8. 트러블슈팅

### 문제 1. Docker daemon 연결 실패

- 문제 상황: `docker info` 실행 시 Docker daemon 연결 오류 발생
- 원인 가설: OrbStack이 실행되지 않았거나 Docker Engine이 아직 올라오지 않은 상태
- 확인 방법: OrbStack 앱 실행 여부 확인 후 `docker info` 재실행
- 해결 방법: OrbStack을 실행한 뒤 잠시 기다리고 다시 명령을 실행하여 해결

### 문제 2. 포트 충돌 또는 컨테이너 이름 충돌

- 문제 상황: `docker run -d --name week1-web -p 8080:80 ...` 실행 시 충돌 발생
- 원인 가설: 기존에 같은 이름의 컨테이너가 있거나 8080 포트를 다른 프로세스가 사용 중
- 확인 방법:
  - `docker ps -a`
  - `lsof -i :8080`
- 해결 방법:
  - 기존 컨테이너 삭제: `docker rm -f week1-web`
  - 다른 포트 사용: `-p 8082:80`

> 위 2개는 예시다. 실제 제출 시에는 본인이 직접 겪은 문제/원인/확인/해결 과정으로 바꾸는 것이 가장 좋다.

---

## 9. 보안 및 개인정보 보호

- GitHub 토큰, 비밀번호, 인증 코드, 개인 이메일 전체 주소 등 민감정보는 README와 캡처 이미지에서 마스킹했다.
- 브라우저/터미널/VSCode 캡처 시 민감정보 노출 여부를 최종 확인했다.
- 저장소 공개 전 불필요한 로그나 개인정보가 포함되지 않았는지 재검토했다.

---

## 10. 최종 정리

이번 과제를 통해 macOS(iMac) 환경에서 OrbStack 기반 Docker 사용법과 터미널 기본 조작, 권한 개념, 컨테이너와 이미지의 차이, Dockerfile을 통한 커스텀 이미지 제작, 포트 매핑, Bind Mount, Volume 영속성, Git/GitHub 연동 흐름을 직접 실습했다.  
특히 README만 보더라도 수행 절차와 결과를 재현할 수 있도록 명령어, 출력 결과, 캡처, 설명을 함께 정리했다.
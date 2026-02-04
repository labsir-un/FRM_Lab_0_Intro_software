<div align="center">
<picture>
    <source srcset="https://imgur.com/5bYAzsb.png" media="(prefers-color-scheme: dark)">
    <source srcset="https://imgur.com/Os03JoE.png" media="(prefers-color-scheme: light)">
    <img src="https://imgur.com/Os03JoE.png" alt="Escudo UNAL" width="350px">
</picture>

<h3>Curso de Fundamentos de Robótica Móvil</h3>

<h1>Herramientas de Software</h1>

<h2>Instalación de ROS Noetic</h2>

<h5>Pedro Fabián Cárdenas Herrera<br>
    Ricardo Emiro Ramírez Heredia<br>

<h6>Universidad Nacional de Colombia<br>
    Facultad de Ingeniería<br>
    Departamento de Ingeniería Mecánica y Mecatrónica<br>
    Bogotá, Colombia<br>
    2026</h6>
</div>

<details>
    <summary>🗂️ Tabla de Contenido</summary>

<!-- TOC -->
- [1. 🧰 Herramientas Necesarias](#1--herramientas-necesarias)
  - [1.1. 🔭🛠️ Equipos](#11-️-equipos)
  - [1.2. 🖥️💾 Software](#12-️-software)
- [2. 🔧️➡️🚀 Procedimiento](#2-️️-procedimiento)
- [4. 📚🗄️ Referencias](#4-️-referencias)

</details>

---

<h1> 🖥️📂 Guía 0 - Instalación de ROS Noetic</h1>

## 1. 🧰 Herramientas Necesarias

### 1.1. 🔭🛠️ Equipos

  - Computador.

### 1.2. 🖥️💾 Software

  - Navegador web.
  - Terminal

### 1.3 Instalar Visual Studio Code (VS Code) en Ubuntu

Opción A (recomendada): repositorio oficial de Microsoft (auto-updates)

Ejecuta esto en la terminal:

```sh
sudo apt update
sudo apt-get install -y wget gpg

# 1) Importar llave y guardarla como keyring
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg

# 2) Agregar el repo (formato .sources / Deb822)
sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null <<'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

# 3) Instalar
sudo apt update
sudo apt install -y code
```

Para abrirlo:

```sh
code
```

### 1.4 Instalar Terminator en Ubuntu

```sh
sudo apt update
sudo apt install -y terminator
```

## 2. 🔧️➡️🚀 Procedimiento

1. Abra una nueva terminal.
2. Configure su source.list para que su comptador acepte el software de packages.ros.org

```sh
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
```

3. Configure sus llaves

```sh
sudo apt install curl # if you haven't already installed curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
```

4. Instale de la versión completa

```sh
sudo apt update
sudo apt install ros-noetic-desktop-full
```

5. Configure su entorno.

    - Bash
    ```sh
    echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
    source ~/.bashrc
    ```
    - zsh
    ```sh
    echo "source /opt/ros/noetic/setup.zsh" >> ~/.zshrc
    source ~/.zshrc
    ```

6. Instale las dependencias para construir paquetes.

```sh
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
```

7. Inicialice rosdep.

```sh
sudo rosdep init
rosdep update
```

8. Verifique la intalacion viendo la versión intalada.

```sh
rosversion -d
```

>[!NOTE]
>Una vez que instalas ROS, notarás que catkin funciona como un compilador de paquetes. El comando catkin_make compila todo el espacio de trabajo, lo cual no supone un problema si solo tienes unos pocos paquetes ligeros. Sin embargo, si tu espacio de trabajo contiene muchos paquetes, es recomendable instalar catkin_build, ya que permite compilarlos de forma independiente.
>```sh
>sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
>wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
>sudo apt-get update
>sudo apt-get install python3-catkin-tools
>```

## 3. 🔧️➡️🚀 Pruebas de Funcionamiento

Proyecto completo en ROS Noetic (ROS 1) con Python3 que crea y prueba:

✅ Tópico (publisher/subscriber)

✅ Servicio (server/client)

✅ Acción (action server/client con feedback) 

✅ Parámetros (set/get desde CLI y desde código)


### 3.1 Preparación (workspace + paquete)

```sh
# 1) Cargar ROS
source /opt/ros/noetic/setup.bash

# 2) Crear workspace
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
catkin_make
source devel/setup.bash

# 3) Crear paquete (con dependencias)
cd ~/catkin_ws/src
catkin_create_pkg demo_comm rospy std_msgs message_generation actionlib actionlib_msgs

# 4) Estructura de carpetas
cd demo_comm
mkdir -p scripts msg srv action
```

### 3.2 Tópico (Topic): Publisher + Subscriber

#### 3.2.1 Publisher: `scripts/talker.py`

```python
#!/usr/bin/env python3
import rospy
from std_msgs.msg import String

def main():
    rospy.init_node("talker_demo")

    # Parámetro (ejemplo)
    rate_hz = rospy.get_param("~rate_hz", 2)
    greeting = rospy.get_param("~greeting", "Hola desde ROS Topic")

    pub = rospy.Publisher("/demo/chatter", String, queue_size=10)
    rate = rospy.Rate(rate_hz)

    i = 0
    while not rospy.is_shutdown():
        msg = f"{greeting} #{i}"
        pub.publish(msg)
        rospy.loginfo(f"Publicado: {msg}")
        i += 1
        rate.sleep()

if __name__ == "__main__":
    main()
```

#### 3.2.1 Subscriber: `scripts/listener.py`

```python
#!/usr/bin/env python3
import rospy
from std_msgs.msg import String

def cb(msg: String):
    rospy.loginfo(f"Recibido: {msg.data}")

def main():
    rospy.init_node("listener_demo")
    rospy.Subscriber("/demo/chatter", String, cb)
    rospy.spin()

if __name__ == "__main__":
    main()
```

### 3.3 Servicio (Service): Definición + Server + Client

#### 3.3.1 Definir servicio: `srv/AddTwoInts.srv`

```srv
int64 a
int64 b
---
int64 sum
```

#### 3.3.2 Server: `scripts/add_server.py`

```python
#!/usr/bin/env python3
import rospy
from demo_comm.srv import AddTwoInts, AddTwoIntsResponse

def handle(req):
    rospy.loginfo(f"Servicio llamado: a={req.a}, b={req.b}")
    return AddTwoIntsResponse(req.a + req.b)

def main():
    rospy.init_node("add_server_demo")
    srv = rospy.Service("/demo/add_two_ints", AddTwoInts, handle)
    rospy.loginfo("Servicio /demo/add_two_ints listo.")
    rospy.spin()

if __name__ == "__main__":
    main()
```

#### 3.3.3 Client: `scripts/add_client.py`

```python
#!/usr/bin/env python3
import rospy
from demo_comm.srv import AddTwoInts

def main():
    rospy.init_node("add_client_demo")
    rospy.wait_for_service("/demo/add_two_ints")
    add = rospy.ServiceProxy("/demo/add_two_ints", AddTwoInts)

    a = rospy.get_param("~a", 2)
    b = rospy.get_param("~b", 3)

    resp = add(a, b)
    rospy.loginfo(f"Resultado: {a} + {b} = {resp.sum}")

if __name__ == "__main__":
    main()
```

### 3.4 Acción (Action): Definición + Action Server + Action Client

>Acciones sirven para tareas “largas” con feedback (a diferencia del servicio, que es request/response y ya).

#### 3.4.1 Definir acción: `action/Countdown.action`

```action
# Goal
int32 seconds
---
# Result
bool success
---
# Feedback
int32 remaining
```

#### 3.4.2 Action Server: `scripts/countdown_server.py`

```python
#!/usr/bin/env python3
import rospy
import actionlib
from demo_comm.msg import CountdownAction, CountdownFeedback, CountdownResult

class CountdownServer:
    def __init__(self):
        self.server = actionlib.SimpleActionServer(
            "/demo/countdown",
            CountdownAction,
            execute_cb=self.execute,
            auto_start=False
        )
        self.server.start()
        rospy.loginfo("Action server /demo/countdown listo.")

    def execute(self, goal):
        feedback = CountdownFeedback()
        result = CountdownResult()

        secs = max(0, int(goal.seconds))
        rate = rospy.Rate(1)

        for remaining in range(secs, -1, -1):
            if self.server.is_preempt_requested():
                rospy.logwarn("Acción preempted/cancelada.")
                result.success = False
                self.server.set_preempted(result)
                return

            feedback.remaining = remaining
            self.server.publish_feedback(feedback)
            rospy.loginfo(f"Quedan: {remaining} s")
            rate.sleep()

        result.success = True
        self.server.set_succeeded(result)
        rospy.loginfo("Cuenta regresiva terminada.")

def main():
    rospy.init_node("countdown_server_demo")
    CountdownServer()
    rospy.spin()

if __name__ == "__main__":
    main()
```

#### 3.4.3 Action Client: `scripts/countdown_client.py`

```python
#!/usr/bin/env python3
import rospy
import actionlib
from demo_comm.msg import CountdownAction, CountdownGoal

def feedback_cb(fb):
    rospy.loginfo(f"Feedback: remaining={fb.remaining}")

def main():
    rospy.init_node("countdown_client_demo")
    client = actionlib.SimpleActionClient("/demo/countdown", CountdownAction)
    rospy.loginfo("Esperando action server...")
    client.wait_for_server()

    seconds = rospy.get_param("~seconds", 5)
    goal = CountdownGoal(seconds=seconds)

    rospy.loginfo(f"Enviando goal: {seconds} segundos")
    client.send_goal(goal, feedback_cb=feedback_cb)

    client.wait_for_result()
    res = client.get_result()
    rospy.loginfo(f"Resultado: success={res.success}")

if __name__ == "__main__":
    main()
```

### 3.5 Configurar `CMakeLists.txt` y `package.xml` (para msg/srv/action)

#### 3.5.1 Edita `CMakeLists.txt`

Busca/ajusta estas secciones:

##### 3.5.1.1 `message_generation`

```cmake
find_package(catkin REQUIRED COMPONENTS
  rospy
  std_msgs
  message_generation
  actionlib
  actionlib_msgs
)
```
##### 3.5.1.2 `agregar archivos`

```cmake
add_service_files(
  FILES
  AddTwoInts.srv
)

add_action_files(
  DIRECTORY action
  FILES Countdown.action
)

generate_messages(
  DEPENDENCIES
  std_msgs
  actionlib_msgs
)
```

##### 3.5.1.3 `catkin_package`

```cmake
catkin_package(
  CATKIN_DEPENDS rospy std_msgs message_runtime actionlib actionlib_msgs
)
```

#### 3.5.2 Edita `package.xml` (dependencias)

```xml
<build_depend>message_generation</build_depend>
<exec_depend>message_runtime</exec_depend>

<depend>actionlib</depend>
<depend>actionlib_msgs</depend>
<depend>rospy</depend>
<depend>std_msgs</depend>
```

### 3.6 Compilar + dar permisos a scripts

```sh
cd ~/catkin_ws
catkin_make
source devel/setup.bash

chmod +x ~/catkin_ws/src/demo_comm/scripts/*.py
```

### 3.6 Cómo probar todo

#### 3.6.1 Tópico

`Terminal 1`

```sh
roscore
```

`Terminal 2`

```sh
source ~/catkin_ws/devel/setup.bash
rosrun demo_comm talker.py _rate_hz:=2 _greeting:="Hola estudiantes"
```

`Terminal 3`

```sh
source ~/catkin_ws/devel/setup.bash
rosrun demo_comm listener.py
```

`Comandos útiles:`

```sh
rostopic list
rostopic echo /demo/chatter
rostopic hz /demo/chatter
```

#### 3.6.2 Servicio

`Terminal 2`

```sh
source ~/catkin_ws/devel/setup.bash
rosrun demo_comm add_server.py
```

`Terminal 3`

```sh
source ~/catkin_ws/devel/setup.bash
rosrun demo_comm add_client.py _a:=10 _b:=25
```

`Comandos útiles:`

```sh
rosservice list
rosservice call /demo/add_two_ints "a: 7
b: 8"
```

#### 3.6.3 Acción

`Terminal 2`

```sh
source ~/catkin_ws/devel/setup.bash
rosrun demo_comm countdown_server.py
```

`Terminal 3`

```sh
source ~/catkin_ws/devel/setup.bash
rosrun demo_comm countdown_client.py _seconds:=6
```

`Comandos útiles:`

```sh
rostopic list | grep countdown
```

#### 3.6.4 Parámetros

`Terminal 2`

```sh
rosparam set /demo_param "valor"
rosparam get /demo_param
rosparam list
```

`Terminal 3`

```sh
rosrun demo_comm talker.py _rate_hz:=5 _greeting:="Hola con params"
```

## 4. 📚🗄️ Referencias

**[1]** P. Cárdenas, "Intro_Ros", 2023. [Online]. Available: [https://github.com/PedroFCardenas/Intro_Ros](https://github.com/PedroFCardenas/Intro_Ros)

**[2]** ROS.org , "Ubuntu install of ROS Noetic", 2023. [Online]. Available: [https://wiki.ros.org/noetic/Installation/Ubuntu](https://wiki.ros.org/noetic/Installation/Ubuntu)

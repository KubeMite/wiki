---
title: 'Store K3S Data on External Disk'
draft: false
weight: 3
series: ["K3S"]
series_order: 3
---

This tutorial shows how to configure K3S to use an external storage device mounted on a Linux file system.

Run the following commands on each node in a cluster after K3S has been installed:

1. Stop the K3S service on managers:

    ```sh
    systemctl stop k3s
    ```

1. Stop the K3S service on agents:

    ```sh
    systemctl stop k3s-agent
    ```

1. Stop any trailing processes by running the following command:

    ```sh
    /usr/local/bin/k3s-killall.sh
    ```

1. Copy all of the K3S data to the mounted storage device:

    ```sh
    mv /run/k3s/ /<disk-mount-folder>/k3s/
    mv /var/lib/kubelet/pods /<disk-mount-folder>/k3s-pods/
    mv /var/lib/rancher/ /<disk-mount-folder>/k3s-rancher/
    mv /var/log/pods/ /<disk-mount-folder>/k3s-pod-log/
    ```

1. Create a symbolic link between the original K3S folders and the new K3S folders so that the K3S can still work correctly but write to the new folders:

    ```sh
    ln -s /<disk-mount-folder>/k3s/ /run/k3s/
    ln -s /<disk-mount-folder>/k3s-pods/ /var/lib/kubelet/pods
    ln -s /<disk-mount-folder>/k3s-rancher/ /var/lib/rancher
    ln -s /<disk-mount-folder>/k3s-pod-logs/ /var/log/pods
    ```

1. Start the K3S service on the managers:

    ```sh
    systemctl start k3s
    ```

1. Start the K3S service on the agents:

    ```sh
    systemctl start k3s-agent
    ```

This can also be done in an ansible playbook:

```yaml
- name: Stop k3s managers
  hosts: Managers
  become: true
  tasks:
  - name: Stop k3s service in managers
    ansible.builtin.shell: systemctl stop k3s

- name: Stop k3s workers
  hosts: Workers
  become: true
  tasks:
  - name: Stop k3s service in workers
    ansible.builtin.shell: systemctl stop k3s-agent

- name: Move k3s storage to external drive
  hosts: all
  become: true
  tasks:
  - name: Kill any trailing k3s services
  ansible.builtin.shell: /usr/local/bin/k3s-killall.sh

  - name: Move k3s folder to external drive
    ansible.builtin.shell: mv /run/k3s/ /<disk-mount-folder>/k3s/
  - name: Move k3s pods folder to external drive
    ansible.builtin.shell: mv /var/lib/kubelet/pods/ /<disk-mount-folder>/k3s-pods/
  - name: Move k3s rancher folder to external drive
    ansible.builtin.shell: mv /var/lib/rancher/ /<disk-mount-folder>/k3s-rancher/
  - name: Move k3s logs of pods folder to external drive
    ansible.builtin.shell: mv /var/log/pods/ /<disk-mount-folder>/k3s-pod-logs/

  - name: Create a symbolic link for k3s folder
    ansible.builtin.file:
      src: /<disk-mount-folder>/k3s/
      dest: /run/k3s
      state: link
  - name: Create a symbolic link for k3s pods folder
    ansible.builtin.file:
      src: /<disk-mount-folder>/k3s-pods/
      dest: /var/lib/kubelet/pods
      state: link
  - name: Create a symbolic link for k3s rancher folder
    ansible.builtin.file:
      src: /<disk-mount-folder>/k3s-rancher/
      dest: /var/lib/rancher
      state: link
  - name: Create a symbolic link for k3s logs of pods folder
    ansible.builtin.file:
      src: /<disk-mount-folder>/k3s-pod-logs/
      dest: /var/log/pods
      state: link

  - name: Pause for 5 seconds to let the symbolic link take effect
    ansible.builtin.pause:
      seconds: 5

- name: Start k3s managers
  hosts: Managers
  become: true
  tasks:
  - name: Start k3s service in managers
    ansible.builtin.shell: systemctl start k3s

- name: Start k3s workers
  hosts: Workers
  become: true
  tasks:
  - name: Start k3s service in workers
    ansible.builtin.shell: systemctl start k3s-agent
```

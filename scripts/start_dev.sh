#!/bin/bash

function init_env() {
    bash init_env.sh
}

function k8s() {
    bash start_k8s.sh
}

function redis() {
    bash start_redis.sh
}
function starrocks() {
    bash start_starrocks.sh
}



function start_project() {
    init_env
    k8s
    redis
}

start

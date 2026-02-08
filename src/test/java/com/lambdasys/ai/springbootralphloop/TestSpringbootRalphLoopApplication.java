package com.lambdasys.ai.springbootralphloop;

import org.springframework.boot.SpringApplication;

public class TestSpringbootRalphLoopApplication {

    public static void main(String[] args) {
        SpringApplication.from(SpringbootRalphLoopApplication::main).with(TestcontainersConfiguration.class).run(args);
    }

}

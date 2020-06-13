package com.example.dummyservice;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    private static int timesHit = 0;
    @GetMapping("/test")
    public String endpoint() {
        return "V2 Times Hit = " + timesHit++;
    }


}

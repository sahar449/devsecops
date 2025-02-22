package com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}

// src/test/java/com/example/AppTest.java
package com.example;

import org.junit.Test;
import static org.junit.Assert.*;

public class AppTest {
    @Test
    public void testApp() {
        assertEquals("Hello, World!", "Hello, World!");
    }
}
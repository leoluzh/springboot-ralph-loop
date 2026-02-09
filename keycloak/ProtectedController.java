package com.lambdasys.ai.springbootralphloop.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;

/**
 * Controlador exemplo com endpoints protegidos pelo Keycloak
 *
 * Para testar:
 * 1. Obter token do Keycloak:
 *    curl -X POST http://localhost:8080/realms/springboot-ralph/protocol/openid-connect/token \
 *      -d "client_id=springboot-ralph-app" \
 *      -d "client_secret=springboot-ralph-secret-key-change-in-production" \
 *      -d "username=user" \
 *      -d "password=user_password" \
 *      -d "grant_type=password"
 *
 * 2. Usar o token para acessar endpoints protegidos:
 *    curl -H "Authorization: Bearer {token}" http://localhost:8081/api/protected/hello
 */
@RestController
@RequestMapping("/api")
public class ProtectedController {

    /**
     * Endpoint público - sem autenticação
     */
    @GetMapping("/public/hello")
    public ResponseEntity<String> publicHello() {
        return ResponseEntity.ok("Hello from public endpoint!");
    }

    /**
     * Endpoint protegido - requer autenticação
     */
    @GetMapping("/protected/hello")
    public ResponseEntity<String> protectedHello() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        return ResponseEntity.ok("Hello, " + username + "!");
    }

    /**
     * Endpoint protegido que retorna informações do usuário
     */
    @GetMapping("/protected/user-info")
    public ResponseEntity<UserInfo> getUserInfo() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth.getPrincipal() instanceof Jwt) {
            Jwt jwt = (Jwt) auth.getPrincipal();

            UserInfo userInfo = new UserInfo();
            userInfo.setUsername(jwt.getClaimAsString("preferred_username"));
            userInfo.setEmail(jwt.getClaimAsString("email"));
            userInfo.setName(jwt.getClaimAsString("name"));
            userInfo.setRoles(auth.getAuthorities().stream()
                .map(a -> a.getAuthority())
                .toList());

            return ResponseEntity.ok(userInfo);
        }

        return ResponseEntity.badRequest().build();
    }

    /**
     * Endpoint protegido - apenas para ADMIN
     */
    @GetMapping("/admin/status")
    public ResponseEntity<String> adminStatus() {
        return ResponseEntity.ok("Admin only - System is running!");
    }

    /**
     * DTO para retornar informações do usuário
     */
    public static class UserInfo {
        private String username;
        private String email;
        private String name;
        private java.util.List<String> roles;

        // Getters e Setters
        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public java.util.List<String> getRoles() {
            return roles;
        }

        public void setRoles(java.util.List<String> roles) {
            this.roles = roles;
        }
    }
}


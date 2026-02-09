package com.lambdasys.ai.springbootralphloop.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

/**
 * Configuração de Segurança com Keycloak OAuth2/OpenID Connect
 *
 * Esta classe configura o Spring Security para usar o Keycloak como provedor
 * de identidade e autenticação usando o protocolo OpenID Connect.
 *
 * Exemplo de uso em REST Controllers:
 * @GetMapping("/api/protected")
 * public ResponseEntity<String> protectedEndpoint(
 *     @AuthenticationPrincipal Jwt jwt) {
 *     String username = jwt.getClaimAsString("preferred_username");
 *     return ResponseEntity.ok("Hello, " + username);
 * }
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Value("${spring.security.oauth2.resourceserver.jwt.issuer-uri}")
    private String issuerUri;

    /**
     * Configura a cadeia de filtros de segurança HTTP
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // Habilitar CORS
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))

            // CSRF - desabilitar para APIs stateless
            .csrf(csrf -> csrf.disable())

            // Configuração de sessão - stateless para APIs REST
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )

            // Autorização de requisições
            .authorizeHttpRequests(authorize -> authorize
                // Endpoints públicos
                .requestMatchers("/", "/login", "/error", "/health").permitAll()
                .requestMatchers("/assets/**", "/css/**", "/js/**").permitAll()
                .requestMatchers("/swagger-ui/**", "/v3/api-docs/**").permitAll()

                // Endpoints de admin (requerem role admin)
                .requestMatchers("/admin/**").hasRole("admin")

                // Endpoints de usuário (requerem autenticação)
                .requestMatchers("/api/user/**").authenticated()
                .requestMatchers("/api/protected/**").authenticated()

                // Dados públicos
                .requestMatchers("/api/public/**").permitAll()

                // Qualquer outra requisição requer autenticação
                .anyRequest().authenticated()
            )

            // OAuth2 Resource Server com JWT
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt.decoder(jwtDecoder()))
            );

        return http.build();
    }

    /**
     * Configura o decodificador JWT usando a URL de descoberta do Keycloak
     */
    @Bean
    public JwtDecoder jwtDecoder() {
        return NimbusJwtDecoder.withIssuerLocation(issuerUri).build();
    }

    /**
     * Configuração de CORS (Cross-Origin Resource Sharing)
     */
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList(
            "http://localhost:3000",
            "http://localhost:8081",
            "http://localhost:8080"
        ));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
        configuration.setAllowedHeaders(Arrays.asList(
            "Authorization",
            "Content-Type",
            "X-Requested-With"
        ));
        configuration.setExposedHeaders(Arrays.asList("Authorization"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}


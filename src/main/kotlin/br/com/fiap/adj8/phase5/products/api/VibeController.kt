package br.com.fiap.adj8.phase5.products.api

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/vibe")
class VibeController {
    @GetMapping
    fun getVibe() = "VIBE CODED CONTROLLER"
}
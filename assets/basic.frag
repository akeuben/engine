#version 450
layout (location=0) in vec3 bColor;
layout (location=0) out vec4 FragColor;

void main() {
    FragColor = vec4(bColor, 1.0f);
}


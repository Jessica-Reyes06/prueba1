import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req) => {
  const { mensaje } = await req.json();

  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer re_BVXbiBxJ_7Rd6RoB3gQXp9VYcJgGvgT91`,
    },
    body: JSON.stringify({
      from: "onboarding@resend.dev",
      to: "jessicareyesmuro@gmail.com",
      subject: "Contacto desde AulaLibre",
      text: mensaje,
    }),
  });

  const data = await res.json();
  console.log('Resend response:', JSON.stringify(data)); // <- aquí
  return new Response(JSON.stringify(data), {
    headers: { "Content-Type": "application/json" },
  });
});
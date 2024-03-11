defmodule RetWeb.Api.V1.EmailController do
  use RetWeb, :controller

  def send_email(conn, %{"email" => email_address, "subject" => subject, "htmlbody" => htmlbody, "body" => body}) do
    # RetWeb.Email.send_email(email_address, subject, body)   # Create your email
    # |> Ret.Mailer.deliver_now() # Send your email
    case RetWeb.Email.send_email(email_address, subject, htmlbody, body)
         |> Ret.Mailer.deliver_now() do
      {:ok, _response} ->
        json(conn, %{status: "success", message: "Email sent successfully."})

      {:error, reason} ->
        json(conn, %{status: "error", message: "Failed to send email.", reason: reason})
    end
  end
end

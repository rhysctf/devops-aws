<?php

class PHP_Email_Form
{
    public $to;
    public $from_name;
    public $from_email;
    public $subject;
    public $message;
    public $headers;
    public $success_message = "Your message has been sent. Thank you!";
    public $error_message = "Sorry, something went wrong. Please try again later.";
    public $ajax = false;

    public function send()
    {
        $this->headers = "From: $this->from_name <$this->from_email>" . "\r\n";
        $this->headers .= "Reply-To: $this->from_email" . "\r\n";
        $this->headers .= "MIME-Version: 1.0" . "\r\n";
        $this->headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";

        if (mail($this->to, $this->subject, $this->message, $this->headers)) {
            return $this->ajax ? $this->success_message : $this->success_message;
        } else {
            return $this->ajax ? $this->error_message : $this->error_message;
        }
    }

    public function add_message($message, $label = '', $length = 0)
    {
        if (!empty($label)) {
            $this->message .= "<p><strong>$label:</strong> ";
        }

        $this->message .= $message;

        if ($length > 0 && strlen($message) > $length) {
            $this->message .= " (Truncated)";
        }

        $this->message .= "</p>";
    }
}
?>

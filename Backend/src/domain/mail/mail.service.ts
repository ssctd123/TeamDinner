import nodemailer from 'nodemailer';

export interface MailInterface {
    to: string | string[];
    cc?: string | string[];
    bcc?: string | string[];
    subject: string;
    text?: string;
    html: string;
}

export default class MailService {
    private static instance: MailService;
    // Create a transport for sending emails (replace with your email service's data)
    const transporter = nodemailer.createTransport({
        service: 'Gmail', // Use your email service
        auth: {
            user: process.env.EMAIL, // Your email address
            pass: process.env.PASSWORD, // Your password
        },
    });

    private constructor() {}
    //INSTANCE CREATE FOR MAIL
    static getInstance() {
        if (!MailService.instance) {
            MailService.instance = new MailService();
        }
        return MailService.instance;
    }

    //SEND MAIL
    async sendMail(
        options: MailInterface
    ) {
        return await this.transporter
            .sendMail({
                from: process.env.EMAIL,
                to: options.to,
                cc: options.cc,
                bcc: options.bcc,
                subject: options.subject,
                text: options.text,
                html: options.html,
            })
            .then((info) => {
                return info;
            });
    }
}
import { HttpException, Injectable } from "@nestjs/common";
import { User } from "../../data/entities/User";
import { UsersRepository } from "../../data/repositories/Firebase/users.repository";
import { hash, uuid } from "../../utils/util";
import { SignupDto } from "../../api/users/models/requests/signup.dto";
import { Auth } from "../../data/entities/Auth";
import { AuthService } from "../auth/auth.service";
import { ModifyDto } from "../../api/users/models/requests/modify.dto";
import generateResetPasswordTemplate from '../templates/resetPasswordTemplate';
import MailService from '../mail/mail.service';

@Injectable()
export class UsersService {
	constructor(
		private usersRepository: UsersRepository,
		private authService: AuthService
	) {}

	async get(id?: string): Promise<User> {
		if (!id) {
			id = (await this.authService.getAuthFromJWT()).id;
		}
		const user = await this.usersRepository.getUser(id);
		if (user) {
			return user;
		} else {
			throw new HttpException("User not found", 404);
		}
	}

	async getWithToken(): Promise<User> {
		const auth: Auth = await this.authService.getAuthFromJWT();
		return await this.get(auth.id);
	}

	async getAll(): Promise<User[]> {
		return await this.usersRepository.getUsers();
	}

	async signup(userQueryDTO: SignupDto): Promise<User> {
		const hashedPassword = await hash(userQueryDTO.password);
		return await this.usersRepository.createUser({
			id: uuid(),
			...userQueryDTO,
			password: hashedPassword
		});
	}

	async modify(modifyDto: ModifyDto): Promise<User> {
		const user: User = await this.getWithToken();
		const updateData: any = {};
		if (modifyDto.firstName) {
			updateData.firstName = modifyDto.firstName;
		}
		if (modifyDto.lastName) {
			updateData.lastName = modifyDto.lastName;
		}
		if (modifyDto.email) {
			updateData.email = modifyDto.email;
		}
		if (modifyDto.venmo) {
			updateData.venmo = modifyDto.venmo;
		}
		if (modifyDto.tipAmount) {
			updateData.tipAmount = modifyDto.tipAmount;
		}
		if (modifyDto.deviceId) {
			updateData.deviceId = modifyDto.deviceId;
		}
		return await this.usersRepository.modify(user.id, updateData);
	}

	async exists(id: string): Promise<boolean> {
		return (await this.get(id)) !== undefined;
	}

	async getWithEmail(email: string): Promise<User> {
		const auth: Auth = await this.authService.getWithEmail(email);
		if (!auth) {
			throw new HttpException("User not found", 404);
		}
		return this.get(auth.id);
	}

	async sendResetPassword(email: string): Promise<Boolean> {
		const user: User = await this.getWithEmail(email);
		if (user) {
			const emailTemplate = generateResetPasswordTemplate(
				'123456',
				user.firstName
			);
			const mailService = MailService.getInstance();
			await mailService.sendMail({
				to: user.email,
				subject: 'Reset Password',
				html: emailTemplate.html,
			});
			return true;
		}
		return false;
	}
}

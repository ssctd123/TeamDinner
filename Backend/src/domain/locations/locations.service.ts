import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { LocationsRepository } from "../../data/repositories/Firebase/locations.repository";
import { Location } from "../../data/entities/Location";
import { LocationCreateDto } from "../../api/locations/models/requests/locationcreate.dto";
import { TeamsService } from "../teams/teams.service";

@Injectable()
export class LocaitonsService {
constructor(
		private locationsRepository: LocationsRepository,
        private teamsService: TeamsService
	) {}

	async createLocation(locationCreateDto: LocationCreateDto): Promise<Location> {
        const team = await this.teamsService.get();
		if (await this.isOwner()) {
			const location = Location.fromDto(locationCreateDto, team.id);
			return await this.pollsRepository.createLocation(location);
		}
		throw new HttpException(
			"You are not the owner of this team",
			HttpStatus.FORBIDDEN
		);
	}
}
import {
    ApiBadRequestResponse,
    ApiBearerAuth,
    ApiCreatedResponse,
    ApiForbiddenResponse,
    ApiNotFoundResponse,
    ApiOkResponse,
    ApiOperation,
    ApiQuery,
    ApiTags,
    ApiUnauthorizedResponse
} from "@nestjs/swagger";
import { Body, Controller, Get, Post, Query } from "@nestjs/common";
import { LocationsService } from "../../domain/locations/locations.service";
import { Location } from "../../data/entities/Location";
import { LocationCreateDto } from "./models/requests/locationcreate.dto";

@ApiBearerAuth("access-token")
@ApiTags("locations")
@Controller("locations")
export class LocationsController {
    constructor(private readonly locationsService: LocationsService) {}

    @ApiOperation({ summary: "Create a new location for team" })
    @ApiCreatedResponse({ description: "Location created", type: Location })
    @ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
    @ApiForbiddenResponse({ description: "Not owner of team" })
    @ApiNotFoundResponse({ description: "Entity not found" })
    @ApiBadRequestResponse({ description: "Invalid location" })
    @Post("create")
    async createLocation(@Body() locationCreateDto: LocationCreateDto): Promise<Location> {
        return await this.locationsService.createLocation(locationCreateDto);
    }
}
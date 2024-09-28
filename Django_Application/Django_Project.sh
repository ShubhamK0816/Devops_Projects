#!/bin/bash

# Deploy a Djangp Application And Handle The Code For Errors

code_clone()
{
    # declareing an array ....
    declare -a my_array

    # Finding the application in the current directory ....

    my_array=($(find . -name "django-notes-app"))

    # Prin the result of an array ....

    echo "${my_array[@]}"

    # Setting default array array index to 0 in order to determine the length of an array ..

    index=0

    # Checking the index value of an array to check whether the application is present or not 
    # If not present then initate the application cloning ....

    if [[ ${my_array[$index]+_} ]]
    then
        echo "The application has already been clone to your system"
        else
        echo "Cloning the code...."
        git clone https://github.com/LondheShubham153/django-notes-app.git
    fi

}
install_requirements()
{
    echo "Installing the required dependencies ...."
    sudo apt-get install docker.io nginx -y ||
    {
        echo "Failed To Install The Dependencies ...."
        return 1
    }
}
required_restarts()
{
    echo "Performing Restarts ...."
    sudo chown "$USER" /var/run/docker.sock
    sudo systemctl enable docker
    sudo systemctl enable nginx
    sudo systemctl restart docker
}
deploy()
{
    echo "Proceeding For Final Deployment ...."
    docker build -t notes-app . && docker run -d -p 8000:8000 notes-app:latest ||
    {
        echo "Failed To Build & Deploy Application ....."
        return 1
    }
}
echo  ********** Deployment Started ************

if code_clone;
then
    echo "Changing The Directory ...." 
    cd django-notes-app || exit 1    
fi
if ! install_requirements
then
    exit 1
fi
if ! required_restarts
then
    exit 1
fi
if ! deploy
then
    echo "Deployment Failed. Mailing the admin ....."
fi

echo *********** Deployment Done *************
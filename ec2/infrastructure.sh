#!/bin/bash
function prepare_data {
    instances=$(aws ec2 describe-instances \
        | jq '[.Reservations[].Instances[]] | map({
            InstanceId: .InstanceId, 
            SubnetId: .SubnetId, 
            HasAnotherEni: (.Tags[]|select(.Key=="HasAnotherEni")|.Value), 
            AssignEip: (.Tags[]|select(.Key=="AssignEip")|.Value), 
            NetworkInterfaceId: .NetworkInterfaces[]|select(.Attachment.DeviceIndex==0)|.NetworkInterfaceId})')
    count=$(jq length <<< $instances)
    if [ $count -gt 0 ] 
    then
        index=0
        while [ $index -lt $count ] 
        do
            if $(jq --raw-output .[$index].HasAnotherEni <<< $instances) 
            then
                instanceId=$(jq --raw-output .[$index].InstanceId <<< $instances)
                subnetId=$(jq --raw-output .[$index].SubnetId <<< $instances)
                is+="$instanceId={\"instance\":"\"$instanceId\"",\"subnet\":"\"$subnetId\""},"
            fi
            if $(jq --raw-output .[$index].AssignEip <<< $instances)
            then
                eip_ni+="\"$(jq --raw-output .[$index].NetworkInterfaceId <<< $instances)\","
            fi
            (( index++ ))
        done
    fi
}
if (( $# != 2 ))
then
    echo "Usage: ./infrastructure.sh [apply|destroy] [*.tfvars file]"
    exit 1
fi
if [ "$1" == "apply" ] 
then
    cd manage-instances
    terraform apply -auto-approve -var-file="../$2"
    if [ $? -eq 0 ]
    then
        prepare_data
        cd ../manage-network
        instance_subnets=$(echo $is)
        network_interfaces_eip=$(echo $eip_ni)
        terraform apply -auto-approve -var='eni_instances={'"$instance_subnets"'}' -var="eip_network_interfaces=[$network_interfaces_eip]"
    fi
fi
if [ "$1" == "destroy" ] 
then
    prepare_data
    cd manage-network
    terraform destroy -auto-approve -var='eni_instances={'"$instance_subnets"'}' -var="eip_network_interfaces=[$network_interfaces_eip]"
    if [ $? -eq 0 ]
    then
        cd ../manage-instances
        terraform destroy -auto-approve -var-file="../$2"
    fi
fi